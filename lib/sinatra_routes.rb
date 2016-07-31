=begin docs

- A modular Sinatra application
- Is assisted by RoutesInit to set up the headless environment.
- Defers most of the work to HeadlessBrowser.

=end


# RouteHelpers module provides instance methods
require_relative("./route_helpers.rb")

require_relative("./macro_helpers.rb")

class Routes < Sinatra::Base
  
  # helper methods for headless environment setup
  include RouteHelpers
  
  # helper methods for macro feature
  include MacroHelpers
  
  # set the root path, used for finding views
  set :root, `pwd`.chomp

  # root route
  get '/' do
    setup_headless_env
    Macro[:status] && add_to_current_macro(params)
    @screenshot, @error = run_commands_and_handle_errors(params, @screenshot)
    @macros = all_macros.ai(html: true) # pretty print
    return erb(:root)
  end
  

  get '/macro_on' do
    return turn_macro_recording_on(params)
  end
  
  get '/macro_off' do
    return turn_macro_recording_off(params)
  end
  
  get "/macro_save" do
    return save_current_macro(params)
  end

  get "/edit_macro" do
  end
  
  get "/delete_macro" do
  end
  
  get "/run_macro" do
  end
end
