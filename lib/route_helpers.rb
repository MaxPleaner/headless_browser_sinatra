=begin docs

- The RouteHelpers module provides a bunch of useful methods to Routes
- It is required from lib/sinatra_routes.rb and included in the Routes class
- The entry points (used by the Routes class) are "setup_headless_env" and "run_commands_and_handle_errors"
=end

module RouteHelpers
  
  # returns [screenshot_path, error_message]
  def run_commands_and_handle_errors(params_obj, most_recent_screenshot)
    rescue_headless_browser_errors_and_messages do
      rescue_selenium_javascript_errors do
        screenshot_path = execute_commands_and_return_screenshot(
          params_obj,
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
    rescue Selenium::WebDriver::Error::JavascriptError => e
      # Will raise a HeadlessBrowserError
      # which is in turn rescued
      self.class::Browser.driver_helpers.error_out(e)
    rescue Selenium::WebDriver::Error::UnhandledAlertError => e
      self.class::Browser.driver_helpers.error_out(
        "An alert or modal appeared which the application doesn't \
        know how to handle."
      )
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
  def execute_commands_and_return_screenshot(params_obj, most_recent_screenshot)
    # generate a new screenshot or don't, depending on the commands being run
    should_send_screenshot = self.class::Browser.process_params(params_obj)
    prevent_unhandled_alert_errors!
    if should_send_screenshot
      self.class::Browser.driver_helpers.sync_scripts
      return self.class::Browser.screenshot
    else
      return most_recent_screenshot
    end
  end
  
  # can't wait for selenium to throw an error about alerts because at that
  # point the error can no longer be handled
  # must always check if there's an alert after running a command
  def prevent_unhandled_alert_errors!
    driver = self.class::Browser.driver_helpers.driver
    alert = driver.switch_to.alert rescue nil # if rescuing, there's no alert
    return self unless alert
    @current_macro_run_halted = true # tell the client not to keep moving through the running macro sequence, if any
                                     # if an alert is raised in a macro, the macro should include a step to handle it.
    text = alert.text
    message = instructions_for_manually_handling_alert(text)
    raise(HeadlessBrowserError, message)
  end
  
  # present instructions to the user so they can handle an alert
  def instructions_for_manually_handling_alert(text)
    <<-TXT
    This alert/prompt/confirm wasn't automatically handled:<br><br>
    #{text}<br><br>
    How to proceed?<br><br>
    <form action='/confirm_alert'>
      <input type='submit' value='confirm'>
      <input type='text' name='text' placeholder='add text'>
    </form><br>
    <form action='/deny_alert'>
      <input type='submit' value='deny'>
    </form>
    TXT
  end
  
  # What to show if there is no new screenshot
  def default_screenshot(message)
    ["./screenshot.jpg", message]
  end


end
