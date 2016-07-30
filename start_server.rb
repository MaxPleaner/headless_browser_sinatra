#!/usr/bin/env ruby

require 'byebug'               # (gem) debugging

require 'headless'             # (gem) headless x environment
require 'sinatra'              # (gem) web server / routes
require 'selenium-webdriver'   # (gem) firefox command runner
require 'timeout'              # (stdlib) stop long-running commands

# HeadlessBrowser class
require './lib/headless_browser'

# Helpers to start the headless browser from within the routes
class RoutesInit
  
  # try and connect to firefox, but don't hang too long upon failure
  def self.connect_to_firefox_with_timeout(num_seconds)
    begin
      Timeout::timeout(num_seconds) { RoutesInit.setup_headless_env }
    rescue Timeout::Error
      raise(
        HeadlessBrowserError,
        "Firefox is taking > #{num_seconds} seconds to connect"
      )
    end
  end
  
  # call methods in lib/headless_env to lauch headless & firefox
  def self.setup_headless_env
    Routes::HeadlessEnv     ||= HeadlessBrowser.start_headless
    Routes::Driver          ||= HeadlessBrowser.start_driver
    Routes::Browser         ||= HeadlessBrowser.new(
                                  Routes::HeadlessEnv,
                                  Routes::Driver
                                )
  end
end

# custom error class for the headless browser
class HeadlessBrowserError < StandardError; end
  
# use raise / rescue to pass around generic messages as well
class HeadlessBrowserMessage < StandardError; end
  
# modular sinatra routes
class Routes < Sinatra::Base
  
  # root route
  get '/' do
    # don't wait a full minute before raising an error if Firefox is unresponsive
    # although this occasionally fails, it seems to be temporary and refreshing the page can help.
    RoutesInit.connect_to_firefox_with_timeout(20)
    begin
      # execute commands on the headless browser by interpreting the params
      # generate a new screenshot or don't, depending on the commands being run
      should_send_screenshot = Browser.process_params(params)
      @screenshot = should_send_screenshot ? Browser.screenshot : @screenshot
    rescue HeadlessBrowserError => e
      @screenshot = "screenshot.jpg" # show the last used screenshot in case of an error
      @error = "Error: #{e}"
    rescue HeadlessBrowserMessage => e # not really an error, but passed as such
      @screenshot = "screenshot.jpg" # show the last used screenshot
      @error = "Message: #{e}"
    end
    # render views/root.erb
    erb :root
  end
  
end

# start the sinatra server
Routes.run!
