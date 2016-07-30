=begin docs

- A modular Sinatra application with only one root ('/')
- Is assisted by RoutesInit to set up the headless environment.
- Defers most of the work to HeadlessBrowser.

=end


# RouteHelpers module provides instance methods
require_relative("./route_helpers.rb")

class Routes < Sinatra::Base
  
  include RouteHelpers
  
  # set the root path, used for finding views
  set :root, `pwd`.chomp

  # root route
  get '/' do
    setup_headless_env
    @screenshot, @error = run_commands_and_handle_errors(params, @screenshot)
    erb :root
  end
  
end
