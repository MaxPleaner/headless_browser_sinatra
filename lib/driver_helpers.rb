
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
  
  # raise an error unless there's a current page
  def ensure_current_page_exists
    unless driver_has_current_page?
      raise(HeadlessBrowserError, "browser has not visited any websites yet")
    end
  end

  # Send the browser to a web page
  def navigate(url)
    driver.navigate.to(url)
    # on new page load, refresh @scripts_been_sent
    @scripts_been_sent = {}
    # send jquery and the on click script to every page
    send_static_script("./public/jquery.js")
    @scripts_been_sent = { 'jquery' => true }
  end
  
   # Click an element on the page based on a CSS selector
  def click_selector(selector)
    ensure_current_page_exists
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
    ensure_current_page_exists
    # send jquery unless it's already loaded
    is_jquery_loaded = driver.execute_script("return typeof($)") == 'function'
    send_static_script("./public/jquery.js") unless is_jquery_loaded
    # always send the on click script in case the listeners were destroyed
    driver.execute_script(on_click_script)
    @scripts_been_sent["on_click"] = true
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
    ensure_current_page_exists
    @scripts_been_sent["jquery.autotype"] ||= send_static_script('./public/jquery.autotype.js')
    script = <<-JS
      var element = window.lastSelectedElement
      if (element) {
        var $el = $(element)
        $el.val("")
        $el.text("")
        $(element).autotype("#{text}")
      }
    JS
    driver.execute_script(script)
  end
  
  # Refresh the page
  def refresh
    ensure_current_page_exists
    driver.execute_script("window.location.reload()")
  end
  
  # Sends a static script such as jquery
  def send_static_script(path)
    ensure_current_page_exists
    script = File.read(path)
    driver.execute_script(script)
    true
  end
  
  # Given a CSS selector, find an element on the page and return it as a Selenium::WebDriver::Element
  # This can be used to send text to inputs, but this app uses jquery.autotype instead
  def find_element_with_selector(selector)
    ensure_current_page_exists
    driver.execute_script("return $('#{selector}')[0]")
  end

  def on_click_script
    ensure_current_page_exists
    <<-JS
    // call 'off' before 'on' to avoid duplicate listeners
     $("input, textarea").off("click").on("click", function(e) {
       var $el = $(e.currentTarget);
       window.lastSelectedElement = $el[0]
       return true
     })
    JS
  end
  
end