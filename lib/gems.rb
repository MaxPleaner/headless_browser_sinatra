=begin docs

- This is all the gem and stdlib dependencies used by the program.
- This file is required by start_server.rb

=end


require 'byebug'               # (gem) debugging
require 'headless'             # (gem) headless x environment
require 'sinatra'              # (gem) web server / routes
require 'selenium-webdriver'   # (gem) firefox command runner
require 'timeout'              # (stdlib) stop long-running commands

