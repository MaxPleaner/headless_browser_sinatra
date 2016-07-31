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
    Selenium::WebDriver::Firefox::Binary.path = "./lib/firefox"
  end
  
  # Create a firefox driver that can be passed to HeadlessBrowser.new
  def self.start_driver
    set_firefox_binary_path!
    driver = Selenium::WebDriver.for(:firefox)
    return driver
  end
  
  # Set the default number of seconds to delay taking a screenshot
  def self.default_screenshot_delay
    # Adding a few seconds delay ensures the headless browser
    # has completed any UI changes
    return 2
  end
  
  # HeadlessBrowser initializer
  def initialize(headless_env, driver)
    @headless_env     = headless_env
    @driver           = driver
    @driver_helpers   = DriverHelpers.new(@driver)
    @screenshot_delay = self.class.default_screenshot_delay
  end
  
  attr_reader   :headless_env,
                :driver,
                :driver_helpers
                
  attr_accessor :screenshot_delay
  
  # Interpret parameters from routes and run commands accordingly
  # returns a boolean indicating whether a screenshot should be taken or not
  def process_params(params_obj)
    # delete remnant screenshot if no page is loaded
    @driver_helpers.ensure_current_page_exists rescue nil
    given_params = transform_params(params_obj)
    # execute each of the commands and track whether the command calls for a screenshot
    should_take_screenshot_results = given_params.map do |name, val|
      val && send_param(name, val)
    end
    return should_take_screenshot_results.any?
  end
  
  # transform the params object
  def transform_params(params_obj)
    params_with_symbol_keys = make_hash_keys_symbols(params_obj)
    return params_with_symbol_keys.merge(
      coords: params_with_symbol_keys[:click_coords]&.split(",")
    )
  end
  
  def make_hash_keys_symbols(hash)
    return hash.reduce({}) { |memo,(k,v)| memo.tap { |m| m[k.to_sym] = v } }
  end
  
  # Run the command indicated by a particular param
  # Returns a bool indicating whether the command calls for a screenshot
  def send_param(name, val)
    return case name
    when :coords
      @driver_helpers.click_coords(val[0], val[1])
      true
    when :url
      val = url_is_really_url?(val) ? val : make_url(val)
      @driver_helpers.navigate(val)
      true
    when :enter_text
      @driver_helpers.enter_text(val)
      true
    when :refresh
      @driver_helpers.refresh
      true
    when :delay_screenshot
      @screenshot_delay = val.to_i
      false
    when :reenable_on_click_script
      @driver_helpers.should_send_click_listeners = true
      false
    when :custom_script
      @driver_helpers.driver.execute_script(val)
      true
    end
  end

  # saves a screenshot to "public/screenshot.jog"
  def screenshot
    # the path sent to clients
    client_screenshot_path = "screenshot.jpg"
    # true location
    screenshot_path = "#{`pwd`.chomp}/public/#{client_screenshot_path}"
    `rm #{screenshot_path}`
    sleep @screenshot_delay
    driver.save_screenshot(screenshot_path)
    return client_screenshot_path
  end
  
  # A pretty lenient check to see if a url is valid
  def url_is_really_url?(url)
    return ["http", "www.", ".com", ".net", ".org", ".edu"].any? do |str|
      url.include?(str)
    end
  end
  
  # Turns "gmail" into "http://gmail.com", for example
  def make_url(txt)
    return "http://#{txt}.com"
  end
  
end




