=begin docs
- This file defines a HeadlessBrowser class which is the main component of the app.
- It is used by the Sinatra routes to run commands on a selenium firefox browser and take screenshots.
- It is required by lib/server_deps.rb.
- It relies on lib/driver_helpers.rb to do a lot of the work when running commands.
- Typical Usage:
  # instantiate the browser
  browser = HeadlessBrowser.new(
    HeadlessBrowser.start_headless,
    HeadlessBrowser.start_driver
  )
  
  # execute the commands instructed by the params
  should_take_screenshot = browser.process_params(params)
  
  # take a screenshot
  public_screenshot_path = browser.screenshot if should_take_screenshot
  
=end


# Load selenium helper methods
require_relative("./driver_helpers.rb")

# Define a class which loads a headless Firefox browser using selenium
class HeadlessBrowser
  DownloadDestinationPath = "/home/max/Downloads"
  
  def self.headless_with_customization
    return Headless.new
    # this can be customized with more options
  end
  
  # Create a headless environment that can be passed to HeadlessBrowser.new
  def self.start_headless
    headless = headless_with_customization
    headless.start
    return headless
  end

  # lib/firefox is a symlink to firefox-sdk/bin/firefox
  def self.set_firefox_binary_path!
    Selenium::WebDriver::Firefox::Binary.path = "./lib/firefox-sdk/bin/firefox"
  end
  
  # Create a firefox driver that can be passed to HeadlessBrowser.new
  def self.start_driver
    set_firefox_binary_path!
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile["browser.download.folderList"] = 2
    profile["browser.download.manager.showWhenStarting"] = false
    profile["browser.download.dir"] = DownloadDestinationPath
    profile["browser.helperApps.neverAsk.saveToDisk"] = self.accepted_mime_types_for_download
    driver = Selenium::WebDriver.for :firefox, :profile => profile
    return driver
  end

  def self.accepted_mime_types_for_download
    [
      "application/vnd.ms-exceltext/csv",
      "application/csv",
      "application/zip",
      "text/csv",
      "application/x-msexcel",
      "application/excel",
      "application/x-excel",
      "application/vnd.ms-excel",
      "image/png",
      "image/jpeg",
      "text/html",
      "text/plain",
      "application/msword",
      "application/xml"
    ].join(",")
  end
  
  # HeadlessBrowser initializer
  def initialize(headless_env, driver)
    @headless_env     = headless_env
    @driver           = driver
    @driver_helpers   = DriverHelpers.new(@driver)
    # when the app starts, delete any remnant screenshot from a previous session
    `rm public/screenshot.jpg`
  end
  
  attr_reader   :headless_env,
                :driver,
                :driver_helpers
                
  attr_accessor :screenshot_delay
  
  # Interpret parameters from routes and run commands accordingly
  def process_params(params_obj)
    given_params = transform_params(params_obj)
    # execute each of the commands and track whether the command calls for a screenshot
    given_params.each do |name, val|
      val && send_param(name, val)
    end
    return self
  end
  
  # Transform the params object.
  # Makes the params keys symbols
  # Special cases some commands which take arguments
  def transform_params(params_obj)
    params_with_symbol_keys = make_hash_keys_symbols(params_obj)
    if params_with_symbol_keys.has_key?(:click_coords)
      params_with_symbol_keys.merge(
        click_coords: params_with_symbol_keys[:click_coords]&.split(",")
      )
    elsif params_with_symbol_keys.has_key?(:switch_frame)
      params_with_symbol_keys.merge(
        switch_frame: params_with_symbol_keys[:num]
      )
    else
      params_with_symbol_keys
    end
  end
  
  # Takes a hash and tries to convert all its keys to symbols.
  # Will throw an error if this is not possible.
  def make_hash_keys_symbols(hash)
    return hash.reduce({}) { |memo,(k,v)| memo.tap { |m| m[k.to_sym] = v } }
  end
  
  # Run the command indicated by a particular param
  def send_param(name, val)
    driver_helpers.sync_scripts unless name.in?([:confirm_alert, :deny_alert])
    return case name
    when :click_coords
      @driver_helpers.click_coords(val[0], val[1])
      true
    when :url
      @driver_helpers.navigate(val)
    when :enter_text
      @driver_helpers.enter_text(val)
    when :refresh
      @driver_helpers.refresh
    when :custom_script
      @driver_helpers.driver.execute_script(val)
    when :confirm_alert
      process_confirm_alert_cmd(val)
    when :deny_alert
      process_deny_alert_cmd
    when :switch_frame
      process_switch_frame_cmd(val)
    when :custom_selenium
      eval(val)
    when :restart_browser
      @driver_helpers.driver.close
      @driver_helpers.instance_variable_set(:@driver, Selenium::WebDriver.for(:firefox))
      @driver = @driver_helpers.driver
      `rm public/screenshot.jpg`
    end
  end
  
  def valid_commands_list
    [:click_coords, :url, :enter_text, :refresh, :custom_script, :confirm_alert, :deny_alert, :restart_browser, :switch_frame,
     :custom_selenium]
  end
  
  # switch to a different iframe
  # if given_num is blank, switch to the main document
  def process_switch_frame_cmd(given_num)
    num = given_num.to_i
    driver = @driver_helpers.driver
    if num == 321
      driver.switch_to.default_content
    else
      driver.switch_to.frame(num)
    end
    self
  end
  
  # If there's a pending alert, confirm it (possibly send it text as well)
  def process_confirm_alert_cmd(text)
    text = text.eql?(true) ? nil : text
    driver = @driver_helpers.driver
    alert = driver.switch_to.alert rescue nil
    if !alert
      raise(HeadlessBrowserError, "Cant confirm alert. None was found")
    end
    begin
      alert.send_keys(text) if text
      alert.accept
    rescue StandardError => e
      raise(HeadlessBrowserError, e)
    end
    self
  end
  
  # If there's a pending alert, deny it
  def process_deny_alert_cmd
    driver = @driver_helpers.driver
    alert = driver.switch_to.alert rescue nil
    if !alert
      raise(HeadlessBrowserError, "Cant deny alert. None was found")
    end
    begin
      alert.dismiss
    rescue StandardError => e
      raise(HeadlessBrowserError, e)
    end
    return self
  end


  # saves a screenshot to "public/screenshot.jog"
  def screenshot
    # the path sent to clients
    client_screenshot_path = "screenshot.jpg"
    # true location
    screenshot_path = "public/#{client_screenshot_path}"
    `rm #{screenshot_path}`
    driver_helpers.sync_scripts
    begin
      wait_until_document_is_ready
    rescue Selenium::WebDriver::Error::TimeOutError
      # the document is not ready in 10 seconds for some reason
      # send a screenshot anyway
    end
    driver.save_screenshot(screenshot_path)
    return client_screenshot_path
  end
  
  # don't send screenshots too early.
  def wait_until_document_is_ready
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)
    script = <<-JS
      $(function(){window.isDocumentPrepared = true})
      return window.isDocumentPrepared
    JS
    wait.until { driver_helpers.driver.execute_script(script) }
  end
  
end

