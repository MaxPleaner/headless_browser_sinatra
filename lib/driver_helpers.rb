=begin docs

- DriverHelpers assists in running commands on a selenium firefox browser.
- It is mainly used by lib/headless_browser.rb, which is the point of contact for the Sinatra routes.
- HeadlessBrowser.new acts as a constructor for DriverHelpers
- HeadlessBrowser instances store a reference to a DriverHelpers instance and defer commands to it.
- This plays an important role in the app, and it's best to read through the comments in each method's source code.

- An example of usage:

  # Get an instance via the HeadlessBrowser initializer
  browser = HeadlessBrowser.new(
    HeadlessBrowser.start_headless,
    HeadlessBrowser.start_driver
  )
  driver_helpers = browser.driver_helpers
  
  # run selenium commands (chainable)
  driver_helpers.navigate("http://google.com")
                .ensure_current_page_exists
                .click_selector("input")
                .click_coords(0,0)
                .enter_text("foobar")
                .refresh
                .refresh_failsafe
                .send_jquery_if_undefined
                .find_element_with_selector("input")
  
  # a few other commands (not chainable)
  driver_helpers.driver_has_current_page?
  driver_helpers.send_static_script("./public/jquery.js")
  underlying_driver = driver_helpers.driver
  underlying_driver.execute_script(driver_helpers.on_click_script)
  
=end


# Included by lib/headless_browser.rb
class DriverHelpers
  
  attr_reader   :driver, :scripts_been_sent
  attr_accessor :should_send_click_listeners
  
  def initialize(driver)
    @driver = driver
    
    # avoid re-sending large scripts to the same page
    # i.e. jquery, jquery.autotype
    @scripts_been_sent = {}
                            
    # on click is sent upon every click
    # to ensure that the event listeners are defined
    # Some sites dont allow this, which is why it's a togglable boolean
    @should_send_click_listeners = true
  end
  
  
  # Check if the driver is visiting any page
  def driver_has_current_page?
    return driver.current_url != "about:blank"
  end
  
  # unless there's a current page,
  # raise an error and delete any remnant screenshot
  def ensure_current_page_exists
    unless driver_has_current_page?
      `rm public/screenshot.jpg`
      raise(HeadlessBrowserError, "browser has not visited any websites yet")
    end
    return self
  end

  # Send the browser to a web page
  def navigate(url)
    driver.navigate.to(url)
    sync_scripts
    return self
  end
  
  def sync_scripts
    send_jquery_if_undefined
    send_jquery_autotype_if_undefined
    send_jquery_style_if_undefined
    send_on_click_if_undefined
  end

  # Click an element on the page based on a CSS selector
  # No front-end connection yet exists for this
  def click_selector(selector)
    ensure_current_page_exists
    elements = driver.find_elements(:css, selector)
    if elements.empty?
      raise(HeadlessBrowserError, "CSS selector #{selector} has no matches")
    end
    elements.first.click
    return self
  end
  
  # stop processing commands,
  # refresh the firefox javascript state,
  # and raise an error
  def error_out(text)
     # Refresh the page using Selenium API. Firefox's JS environment resets.
    refresh_failsafe
    raise(HeadlessBrowserError, "#{text}")
  end
  
  # Click x,y coordinates on the page
  def click_coords(x, y)
    ensure_current_page_exists
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
    return self
  end
  
  # Enter text in the currently selected input
  def enter_text(text)
    ensure_current_page_exists
    ensure_element_is_selected
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
    return self
  end
  
  # Raise an error unless window.lastSelectedElement is set
  def ensure_element_is_selected
    is_element_there = driver.execute_script(
      "return (typeof(window.lastSelectedElement) !== 'undefined')"
    )
    if !is_element_there
      error_out("Tried to enter text, but no element is selected")
    end
    return self
  end
  
  # Refresh the page using Javascript
  def refresh
    ensure_current_page_exists
    driver.execute_script("window.location.reload()")
    return self
  end
  
  # Refresh the page using selenium's API
  # in case of halting Javascript errors
  def refresh_failsafe
    navigate(driver.current_url)
    return self
  end
  
  # Sends a static script such as jquery
  def send_static_script(path)
    ensure_current_page_exists
    script = File.read(path)
    driver.execute_script(script)
    return self
  end
  
  # Sends jQuery unless the page already defines jQuery
  def send_jquery_if_undefined
    is_jquery_loaded = driver.execute_script("return typeof($)") == 'function'
    is_jquery_fn_defined = is_jquery_loaded && driver.execute_script(
      "return typeof($.fn)"
    ).eql?('object')
    send_static_script("./public/jquery.js") unless is_jquery_fn_defined
    return self
  end
  
  # Sends jquery autotype unless the page already defines $.fn.autotype
  def send_jquery_autotype_if_undefined
    is_script_loaded = driver.execute_script(
      "return typeof($.fn.autotype)"
    ).eql?('function')
    send_static_script("./public/jquery.autotype.js") unless is_script_loaded
    return self
  end
  
  # This jquery plugin assists in setting styles with the !important tag
  def send_jquery_style_if_undefined
    is_script_loaded = driver.execute_script(
      "return typeof($.fn.style)"
    ).eql?('function')
    send_static_script("./public/jquery.style.js") unless is_script_loaded
    return self
  end
  
  # Sends onclick unless window.hasOnClick is true
  def send_on_click_if_undefined
    is_script_loaded = driver.execute_script(
      "return window.hasOnClick"
    ).to_s.eql?('true')
    driver.execute_script(on_click_script)
    #unless is_script_loaded
    return self
  end

  # Given a CSS selector, find an element on the page and return it as a Selenium::WebDriver::Element
  # This can be used to send text to inputs, but this app uses jquery.autotype instead
  def find_element_with_selector(selector)
    ensure_current_page_exists
    driver.execute_script("return $('#{selector}')[0]")
    return self
  end

  # a script's text, which can be sent to the client via execute_script
  # Practically, this stores a client-side reference to the last input/textarea that was clicked.
  # Unless the user manually types CSS selectors (and there's no UI for this), this is mandatory to support text entry.
  def on_click_script
    ensure_current_page_exists
    script = <<-JS
    window.hasOnClick = true
     $("input, textarea").on("click", function(e) {
       if (window.lastSelectedElement) {
         $(window.lastSelectedElement).style("border", "2px solid green", "important")
       }
       var $el = $(e.currentTarget);
       window.lastSelectedElement = $el[0]
       $el.style("border", "2px solid red", "important")
       return true
     })
    JS
    return script
  end
  
  # to submit a form containing the selected input
  def press_enter
    ensure_element_is_selected
    script = <<-JS
      $(window.lastSelectedElement).parent("form")
    JS
  end

end