Installation:

 1. `sh install.sh`
 2. `bundle`

  _note_ the install script is for Ubuntu x86_64 specifically.
  
  To use this project on a differet system, read the `install.sh` file for a list of dependencies and install them using
  your package manager. Also replace the firefox source url with one compiled for your system's specs.

Usage:

 1. `ruby start_server.rb`
 2. Set `ENV["APP_PORT"]` (defaults to 4567) and `ENV["APP_HOST"]` (defaults to http://localhost) 
 2. visit the root url in the browser

About:

  This is a Sinatra web application.
  
  It uses the `headless` and `selenium-webdriver` gems to launch a firefox browser.
  
  It runs commands on the firefox browser.
  
  It shows the firefox browser's current state as a screenshot
  
  It can forward clicks to the firefox browser, enter text, and execute arbitrary javascript.
  
  It records macros of command sequences and replays them.
  
  It can nest macros.
  
  It handles alerts/prompts/confirms to address selenium's shortcomings.
  
Here's [a screencast](https://www.youtube.com/watch?v=9h89fxNTt7s) to see it in action.

**Update** now supports downloading files.
