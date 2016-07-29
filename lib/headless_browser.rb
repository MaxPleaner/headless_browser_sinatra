
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
  def initialize(headless_env, driver)
    @headless_env, @driver = headless_env, driver
    @driver_helpers = DriverHelpers.new(@driver)
  end
  
  # Take the params from the controller and interpret them to execute code
  def process_params(params)
    given_params = {}
    given_params[:coords]  = params[:click_coords]&.split(",")
    given_params[:url]     = params[:url]
    given_params[:text]    = params[:enter_text]
    given_params[:refresh] = params[:refresh]
    given_params.each do |name, val|
      val && send_param(name, val)
    end
  end

  # Process a single parameter
  def send_param(name, val)
    case name
    when :coords
      @driver_helpers.click_coords(val[0], val[1])
    when :url
      val = val.include?('http') ? val : "http://#{val}.com"
      @driver_helpers.navigate(val)
    when :text
      @driver_helpers.enter_text(val)
    when :refresh
      @driver_helpers.refresh
    end
  end
  
  # saves a screenshot to "public/screenshot.jog"
  def screenshot
    client_screenshot_path = "screenshot.jpg" # the path sent to clients
    screenshot_path = "public/#{client_screenshot_path}" # true location
    `rm #{screenshot_path}`
    driver.save_screenshot(screenshot_path)
    client_screenshot_path
  end
  
end




