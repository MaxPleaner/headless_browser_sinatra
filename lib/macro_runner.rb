# only one macro is run at a time

module MacroRunner

  # responds to /macro_run route
  # runs the first command in the sequence
  # on the client side, a loop is set up to call continue_running_macro
  def start_running_macro(macro_name, list_of_command_hashes)
    running_cmd = Routes::RunningCommand
    if running_cmd[:cmd].empty?
      running_cmd[:name] = macro_name
      running_cmd[:cmd].concat(list_of_command_hashes)
      current_cmd = running_cmd[:cmd].shift
      run_macro_command(macro_name, current_cmd)
    else
      @screenshot, @error = default_screenshot(
        "can't start macro #{macro_name}. A macro is already running.\
        (#{running_cmd[:name]})"
      )
    end
    @macros = all_macros
    return erb(:root)
  end
  
  # responds to /continue_macro_run
  # runs the next command in the Routes::RunningCommand sequence
  def continue_running_macro
    running_cmd = Routes::RunningCommand[:cmd]
    name = Routes::RunningCommand[:name]
    if running_cmd.empty?
      @screenshot, @error = default_screenshot("Macro #{name} is done running.")
    else
      current_cmd = running_cmd.shift
      run_macro_command(name, current_cmd)
    end
    @macros = all_macros
    return erb(:root)
  end
  
  # Runs command and sets up instance variables for the root view
  def run_macro_command(macro_name, current_command)
    setup_headless_env
    @screenshot, @error = run_commands_and_handle_errors(
      current_command,
      'screenshot.jpg'
    )
    @running_macro_name = macro_name
    @running_macro_current_command = current_command
    return self
  end
  
end