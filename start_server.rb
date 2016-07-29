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
  
# modular sinatra routes
class Routes < Sinatra::Base
  
  # root route
  get '/' do
    RoutesInit.connect_to_firefox_with_timeout(20)
    begin
      Browser.process_params(params)
      @screenshot = Browser.screenshot # generate a new screenshot
    rescue HeadlessBrowserError => e
      @screenshot = "screenshot.jpg" # show the last used screenshot
      @error = "Error: #{e}"
    end
    erb :root
  end
  
end

# start the sinatra server
Routes.run!
