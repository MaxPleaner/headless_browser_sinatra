#!/usr/bin/env ruby

require 'headless'
require 'selenium-webdriver'

Headless.new.start

Selenium::WebDriver::Firefox::Binary.path = "./lib/firefox"
driver = Selenium::WebDriver.for(:firefox)

# navigate to the root page, loading the headless browser for the first time
driver.navigate.to('http://localhost:4567')

# visit gmail.com
driver.navigate.to('http://localhost:4567/?url=gmail')

# click an input
driver.navigate.to('http://localhost:4567/?click_coords=524,425')

# enter text
driver.navigate.to('
