#!/usr/bin/env ruby

=begin docs

- This is the entry point to the program.
- First run "sh install.sh" then "bundle" to install the dependencies.
- Then run "ruby start_server.rb".
- This will start a Sinatra app at localhost:4567 by default.
# The root url can be changed with the APP_PORT (defualts to 4567) and APP_HOST (defaults to http://localhost) 
- To interact with the app, visit this address in a browser.

=end

# This app is not truly modular.
# It needs to be run from the root directory
# This is so that path references throughout the app are valid
# Raise an error if this isn't the case
unless `ls`.chomp.include?("start_server.rb")
  raise(StandardError, "The app needs to be run from its root directory")
end

# Set the base url using environment variables, if given.
# defaults to "http://localhost:4567"
AppHost = ENV["APP_HOST"] || "http://localhost"
AppPort = ENV["APP_PORT"] || "4567"
AppBaseUrl = "#{AppHost}:#{AppPort}"

# Global gem requirements
require './lib/gems'

# Loads dependencies in the lib/ directory
require './lib/server_deps'

# modular sinatra routes
require './lib/sinatra_routes.rb'

# start the sinatra server
Routes.run!
