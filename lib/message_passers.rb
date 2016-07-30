# custom error class for the headless browser
class HeadlessBrowserError < StandardError; end
  
# use raise / rescue to pass around generic messages as well
class HeadlessBrowserMessage < StandardError; end

