class HeadlessBrowser

  def self.start_headless
    headless = Headless.new(
      video: {
        frame_rate: 12,
        display: 100, # can be any number, a constant identifier
        keep_alive: true,
        reuse: true,
        codec: 'libx264'
      }
    )
    headless.start
    headless
  end

  def self.start_driver
    Selenium::WebDriver::Firefox::Binary.path = "./lib/firefox"
    driver = Selenium::WebDriver.for(:firefox)
    driver
  end

end
