
require_relative("./driver_helpers.rb")

# headless Firefox browser running using selenium
class HeadlessBrowser
  
  # provides a headless_env that can be passed to initialize
  def self.start_headless
    headless = Headless.new
    headless.start
    headless
  end

  # provides a driver that can be passed to initialize
  def self.start_driver
    Selenium::WebDriver::Firefox::Binary.path = "./lib/firefox"
    driver = Selenium::WebDriver.for(:firefox)
    driver
  end
  
  # HeadlessBrowser should be initialized only once per app
  attr_reader :headless_env, :driver, :driver_helpers
  attr_accessor :screenshot_delay
  def initialize(headless_env, driver)
    @headless_env, @driver = headless_env, driver
    @driver_helpers = DriverHelpers.new(@driver)
    @screenshot_delay = 2 # the default number of seconds to delay taking a screenshot
                          # this ensures that the page's javascript is in a ready state
  end
  
  # Take the params from the controller and interpret them to execute code
  # returns a boolean indicating whether a screenshot should be taken or not
  def process_params(params)
    begin
      @driver_helpers.ensure_current_page_exists
    rescue HeadlessBrowserError
      # it's ok, this just deletes the remnant screenshot if there's no webpage actually loaded
    end
    given_params = {}
    given_params[:coords]                   = params[:click_coords]&.split(",")
    given_params[:url]                      = params[:url]
    given_params[:text]                     = params[:enter_text]
    given_params[:refresh]                  = params[:refresh]
    given_params[:delay_screenshot]         = params[:delay_screenshot]
    given_params[:reenable_on_click_script] = params[:reenable_on_click_script]
    should_take_screenshot_results = given_params.map do |name, val|
      val && send_param(name, val)
    end
    should_take_screenshot_results.any?
  end

  # Process a single parameter
  # each case returns a bool indicating whether a screenshot should be taken
  def send_param(name, val)
    should_take_screenshot = case name
    when :coords
      @driver_helpers.click_coords(val[0], val[1])
      true
    when :url
      val = val.include?('http') ? val : "http://#{val}.com"
      @driver_helpers.navigate(val)
      true
    when :text
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
    end
    return should_take_screenshot
  end
  
  # saves a screenshot to "public/screenshot.jog"
  def screenshot
    client_screenshot_path = "screenshot.jpg" # the path sent to clients
    screenshot_path = "public/#{client_screenshot_path}" # true location
    `rm #{screenshot_path}`
    sleep @screenshot_delay
    driver.save_screenshot(screenshot_path)
    client_screenshot_path
  end
  
end




