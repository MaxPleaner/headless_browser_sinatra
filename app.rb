require 'byebug'
require 'headless'
require 'sinatra'
require 'selenium-webdriver'

class HeadlessBrowser
  def self.start_headless
    headless = Headless.new(
      video: {
        frame_rate: 12,
        codec: 'libx264'
      } 
    )
    headless.start
    headless
  end

  def self.start_driver
    Selenium::WebDriver::Firefox::Binary.path = "./firefox"
    driver = Selenium::WebDriver.for(:firefox)
    driver
  end
  def self.test_driver(driver)
    driver.navigate.to('http://google.com')
    driver.title
  end
end

class Routes < Sinatra::Base
  get '/' do
      headless = HeadlessBrowser.start_headless
      driver = HeadlessBrowser.start_driver
      HeadlessBrowser.test_driver(driver)
  end
end

Routes.run!
