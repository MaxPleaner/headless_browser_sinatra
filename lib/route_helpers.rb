=begin docs

- The RouteHelpers module provides a bunch of useful methods to Routes
- It is required from lib/sinatra_routes.rb and included in the Routes class
- The entry points (used by the Routes class) are "setup_headless_env" and "run_commands_and_handle_errors"
=end

module RouteHelpers
  
  # saves params to the Macros object
  def add_to_current_macro(params_obj)
    self.class::CurrentMacro.push(params_obj)
  end
  
  # returns [screenshot_path, error_message]
  def run_commands_and_handle_errors(params, most_recent_screenshot)
    rescue_headless_browser_errors_and_messages do
      rescue_selenium_javascript_errors do
        screenshot_path = execute_commands_and_return_screenshot(
          params,
          most_recent_screenshot
         )
         error_message = nil
        [screenshot_path, error_message]
      end
    end
  end
  
  def rescue_selenium_javascript_errors(&blk)
    begin
      blk.call
    rescue Selenium::WebDriver::Error => e
      # Will raise a HeadlessBrowserError
      # which is in turn rescued
      self.class::Browser.error_out(e)
    end
  end
  
  def rescue_headless_browser_errors_and_messages(&blk)
    begin
      blk.call
    rescue HeadlessBrowserError => e
      default_screenshot("Error: #{e}")
    rescue HeadlessBrowserMessage => e
      default_screenshot("Message: #{e}")
    end
  end
  
  # don't wait a full minute before raising an error if Firefox is unresponsive
  def setup_headless_env
    # although this occasionally fails, it seems to be temporary and refreshing the page can help.
    RoutesInit.connect_to_firefox_with_timeout(20)
  end

  # execute commands on the headless browser by interpreting the params
  def execute_commands_and_return_screenshot(params, most_recent_screenshot)
    # generate a new screenshot or don't, depending on the commands being run
    should_send_screenshot = self.class::Browser.process_params(params)
    if should_send_screenshot
      self.class::Browser.driver_helpers.sync_scripts
      return self.class::Browser.screenshot
    else
      return most_recent_screenshot
    end
  end
  
  # What to show if there is no new screenshot
  def default_screenshot(message)
    ["./screenshot.jpg", message]
  end


end
