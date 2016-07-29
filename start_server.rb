#!/usr/bin/env ruby

require 'byebug'

require 'headless'
require 'sinatra'
require 'selenium-webdriver'

require './lib/headless_browser'

class Routes < Sinatra::Base
  get '/' do
      Headless.new.start # not sure why this is needed, but it is
      Routes::Headless ||= HeadlessBrowser.start_headless
      Routes::Driver ||= HeadlessBrowser.start_driver
      puts "driver loaded"
      Routes::Driver.navigate.to("http://#{params[:url]}.com")
      Routes::Driver.title
  end
end

Routes.run!
