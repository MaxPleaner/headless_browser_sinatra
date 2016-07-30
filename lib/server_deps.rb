=begin docs

- This file is required from start_server.rb
- It loads up further dependencies for the server.

=end

# HeadlessBrowser class
require './lib/headless_browser'

# RoutesInit class
# Helpers to start the headless browser from within the routes
require './lib/routes_init'

# HeadlessBrowserError and HeadlessBrowserMessage classes
# Used to pass errors and messages
require './lib/message_passers.rb'

