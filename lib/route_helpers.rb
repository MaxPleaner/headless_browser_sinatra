=begin docs

- The RouteHelpers module provides a bunch of useful methods to Routes
- It is required from lib/sinatra_routes.rb and included in the Routes class
- The entry points (used by the Routes class) are "setup_headless_env" and "run_commands_and_handle_errors"
=end

module RouteHelpers
  
  # runs the commands detailed in the params.
  # takes a screenshot or returns the most recent screenshot, depending on the command.
  # returns [screenshot_path, error_message]
  def run_commands_and_handle_errors(params_obj)
    rescue_headless_browser_errors_and_messages do
      rescue_selenium_javascript_errors do
        ensure_params_contains_a_command(params_obj)
        screenshot_path = execute_commands_and_return_screenshot(params_obj)
        [screenshot_path, nil]
      end
    end
  end
  
  # If the params are empty (i.e. the browser goes to "localhost:4567")
  # prevent any screenshot being taken by raising a HeadlessBrowserMessage
  # This gets rescued by "rescue_headless_browser_errors_and_messages" to show the most recent screenshot, if one exists
  def ensure_params_contains_a_command(params_obj)
    unless self.class::Browser.valid_commands_list.any? { |key| params_obj[key.to_s] }
      raise(HeadlessBrowserMessage, "")
    end
  end
  
  # Run a block of code and handle the case when Selenium throws an error
  # When rescuing these errors, a HeadlessBrowserError message is thrown
  # which is in turn rescued by "rescue_headless_browser_errors_and_messages"
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
  
  # rescue HeadlessBrowserError and HeadlessBrowserMessages by displaying the message and displaying the most recent screenshot
  def rescue_headless_browser_errors_and_messages(&blk)
    begin
      blk.call
    rescue HeadlessBrowserError => e
      default_screenshot("#{e}")
    rescue HeadlessBrowserMessage => e
      default_screenshot("#{e}")
    end
  end
  
  # don't wait a full minute before raising an error if Firefox is unresponsive
  def setup_headless_env
    # although this occasionally fails, it seems to be temporary and refreshing the page can help.
    RoutesInit.connect_to_firefox_with_timeout(20)
  end

  # execute commands on the headless browser by interpreting the params
  # Some command raise a HeadlessBrowserError or HeadlessBrowserMessage,
  # in which case the screenshot will not be taken.
  # A rescue block in "rescue_headless_browser_errors_and_messages" will handle these cases.
  def execute_commands_and_return_screenshot(params_obj)
    self.class::Browser.driver_helpers.sync_scripts
    self.class::Browser.process_params(params_obj)
    prevent_unhandled_alert_errors! # check for alerts after running commands so that the UI can be updated
    return self.class::Browser.screenshot
  end
  
  # can't wait for selenium to throw an error about alerts because at that
  # point the error can no longer be handled
  # must always check if there's an alert after running a command
  def prevent_unhandled_alert_errors!
    driver = self.class::Browser.driver_helpers.driver
    alert = driver.switch_to.alert rescue nil # if rescuing, there's no alert
    if alert
      unless ['confirm_alert', 'deny_alert'].any? { |key| self.class::RunningCommand[:cmd][0]&.has_key?(key) }
        @current_macro_run_halted = true # make sure that a running macro is halted if the user
                                         # hasn't enqueued a response to the alert
      end
      text = alert.text
      message = instructions_for_manually_handling_alert(text)
      raise(HeadlessBrowserMessage, message)
    else
      return self
    end
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
