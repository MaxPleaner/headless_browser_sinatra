=begin docs

- A modular Sinatra application
- Is assisted by RoutesInit to set up the headless environment.
- One route ("/") handles all the interaction with the selenium environment.
  It uses the RouteHelpers module
- The other routes all have to do with macro recording.
  i.e. recording sequences of selenium commands
  They use the MacroHelpers module
-

=end

# RouteHelpers module provides instance methods
require_relative("./route_helpers.rb")

# MacroHelpers help with macro routes
require_relative("./macro_helpers.rb")

class Routes < Sinatra::Base
  
  # helper methods for headless environment setup
  include RouteHelpers
  
  # helper methods for macro feature
  include MacroHelpers
  
  # set the root path, used for finding views
  set :root, `pwd`.chomp

  # root route, handles all selenium interaction
  get '/' do
    setup_headless_env
    Macro[:status] && add_to_current_macro(params)
    @screenshot, @error = run_commands_and_handle_errors(params, @screenshot)
    @macros = all_macros
    return erb(:root)
  end
  
  # to begin recording a macro
  get '/macro_on' do
    return turn_macro_recording_on(params)
  end
  
  # to stop recording a macro
  get '/macro_off' do
    return turn_macro_recording_off(params)
  end
  
  # to save the current macro to the db
  get "/macro_save" do
    return save_current_macro(params)
  end

  # to show the edit form for a macro
  get "/macro_edit" do
    return edit_macro(params)
  end
  
  # to save an update to a macro
  get "/macro_update" do
    return update_macro(params)
  end
  
  # to destroy a macro
  get "/macro_delete" do
    return delete_macro(params)
  end
  
  # Initialize a macro run sequence
  # It will run the first command in the sequence then have the
  # client automatically hit /continue_macro_run on an interval.
  get "/macro_run" do
    return replay_macro(params)
  end
  
  # to continue running a macro
  # this route does not need to be manually visited.
  # the client will do it automatically after the macro run is initialized.
  get "/continue_macro_run" do
    return continue_macro_run
  end
  
  get "/confirm_alert" do
    setup_headless_env
    text = params[:text]
    cmd = { 'confirm_alert' => text.blank? ? true : text }
    @screenshot, @error = run_commands_and_handle_errors(cmd, 'screenshot.jpg')
    Macro[:status] && add_to_current_macro(cmd)
    @macros = all_macros
    return erb(:root)
  end
  
  get "/deny_alert" do
    setup_headless_env
    cmd = { 'deny_alert' => true }
    @screenshot, @error = run_commands_and_handle_errors(cmd, 'screenshot.jpg')
    Macro[:status] && add_to_current_macro(cmd)
    @macros = all_macros
    return erb(:root)
  end
  
end
