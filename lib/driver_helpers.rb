
# Included by lib/headless_browser.rb
class DriverHelpers
  
  attr_reader :driver, :scripts_been_sent
  def initialize(driver)
    @driver = driver
    @scripts_been_sent = {} # avoid re-sending large scripts to the same page
                            # i.e. jquery, jquery.autotype
  end
  
  
  # Check if the driver is visiting any page
  def driver_has_current_page?
    driver.current_url != "about:blank"
  end

  # Send the browser to a web page
  def navigate(url)
    driver.navigate.to(url)
    # on new page load, refresh @scripts_been_sent
    @scripts_been_sent = {}
    # send jquery and the on click script to every page
    send_static_script("./public/jquery.js")
    driver.execute_script(on_click_script)
    @scripts_been_sent = { 'jquery' => true, 'on_click' => true }
  end
  
   # Click an element on the page based on a CSS selector
  def click_selector(selector)
    return unless driver_has_current_page?
    begin
      elements = driver.find_elements(:css, selector)
      if elements.empty?
        raise(HeadlessBrowserError, "CSS selector #{selector} has no matches")
      else
        elements.first.click
      end
    rescue Selenium::WebDriver::Error::InvalidSelectorError
      raise(HeadlessBrowserError, "CSS selector #{selector} is invalid")
    end
  end
  
  # Click x,y coordinates on the page
  def click_coords(x, y)
    return unless driver_has_current_page?
    javascript_code = <<-JS
      var x = #{x};
      var y = #{y};
      var ev = new MouseEvent('click', {
          'view': window,
          'bubbles': true,
          'cancelable': true,
          'screenX': x,
          'screenY': y
      });
      var el = document.elementFromPoint(x, y);
      el.dispatchEvent(ev);
    JS
    driver.execute_script(javascript_code)
  end
  
  # Enter text in the currently selected input
  def enter_text(text)
    return unless driver_has_current_page?
    @scripts_been_sent["jquery.autotype"] ||= send_static_script('./public/jquery.autotype.js')
    script = <<-JS
      var element = window.lastSelectedElement
      if (element) {
        $(element).autotype("#{text}")
      }
    JS
    byebug
    driver.execute_script(script)
  end
  
  # Refresh the page
  def refresh
    return unless driver_has_current_page?
  end
  
  # Sends a static script such as jquery
  def send_static_script(path)
    return unless driver_has_current_page?
    script = File.read(path)
    driver.execute_script(script)
    true
  end
  
  # Given a CSS selector, find an element on the page and return it as a Selenium::WebDriver::Element
  # This can be used to send text to inputs, but this app uses jquery.autotype instead
  def find_element_with_selector(selector)
    return unless driver_has_current_page?
    driver.execute_script("return $('#{selector}')[0]")
  end

  def on_click_script
    return unless driver_has_current_page?
    <<-JS
     $("input, textarea").on("click", function(e) {
       var $el = $(e.currentTarget);
       window.lastSelectedElement = $el[0]
       true
     })
    JS
  end
  
end