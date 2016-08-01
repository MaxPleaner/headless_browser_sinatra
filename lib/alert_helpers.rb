=begin docs

- Helpers for some routes relating to selenium alert handling
- If an alert/confirm/prompt is raised in Selenium, one of these routes needs to be run or there will be an error
- the next time Javascript is executed.

=end

module AlertHelpers

  # Accepts an alert, and enters text if needed (i.e. for a prompt)
  # This is the response to the /confirm_alert route
  # The command is eventually forwarded to HeadlessBrowser#process_confirm_alert_cmd
  def confirm_alert
    setup_headless_env
    text = params[:text]
    cmd = { 'confirm_alert' => text.blank? ? true : text }
    @screenshot, @error = run_commands_and_handle_errors(cmd)
    self.class::Macro[:status] && add_to_current_macro(cmd)
    @macros = all_macros
    return erb(:root)
  end

  # Denies an alert
  # This is the response to the /deny_alert route
  # The command is eventually forwarded to HeadlessBrowser#process_deny_alert_cmd
  def deny_alert
    setup_headless_env
    cmd = { 'deny_alert' => true }
    @screenshot, @error = run_commands_and_handle_errors(cmd)
    self.class::Macro[:status] && add_to_current_macro(cmd)
    @macros = all_macros
    return erb(:root)
  end

end
