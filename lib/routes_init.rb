=begin docs

- The RoutesInit class is called from the Sinatra '/' route.
- It is only called once per application.
- It is triggered the first time a client makes a request to the server.
- It launches a headless browser environment which is stored as a constant for future use.
- This file is required by lib/server_deps.rb
- Typical usage:
  
  # run it in a Sinatra route
  class Routes < Sinatra::Base
    get '/' do
      RoutesInit.connect_to_firefox_with_timeout(20)
    end
  end
  
=end

# RoutesInit class initializes the headless environment in the scope of the Sinatra app
class RoutesInit
  
  # try and connect to firefox, but don't hang too long upon failure
  def self.connect_to_firefox_with_timeout(num_seconds)
    begin
      Timeout::timeout(num_seconds) do
        RoutesInit.setup_headless_env
      end
    rescue Timeout::Error
      raise(
        HeadlessBrowserError,
        "Firefox is taking > #{num_seconds} seconds to connect"
      )
    end
  end
  
  # call methods in lib/headless_browser to lauch headless & firefox
  # The Routes::Browser constant is the main access point to the headless environment.
  def self.setup_headless_env
    Routes::HeadlessEnv     ||= HeadlessBrowser.start_headless
    Routes::Driver          ||= HeadlessBrowser.start_driver
    Routes::Browser         ||= HeadlessBrowser.new(
                                  Routes::HeadlessEnv,
                                  Routes::Driver
                                )
  end
  
end

