var search_data = {"index":{"searchIndex":["alerthelpers","driverhelpers","headlessbrowser","headlessbrowsererror","headlessbrowsermessage","macrohelpers","macrorunner","routehelpers","routes","routesinit","add_macro_to_current_macro()","add_to_current_macro()","all_macros()","click_coords()","click_selector()","confirm_alert()","connect_to_firefox_with_timeout()","continue_macro_run()","continue_running_macro()","db()","default_screenshot()","delete_macro()","deny_alert()","driver_has_current_page?()","edit_macro()","ensure_current_page_exists()","ensure_element_is_selected()","ensure_params_contains_a_command()","enter_text()","error_out()","execute_commands_and_return_screenshot()","expand_macro_into_running_command()","find_element_with_selector()","headless_with_customization()","included()","instructions_for_manually_handling_alert()","macro_content_is_valid?()","macro_update_error_msg()","make_hash_keys_symbols()","make_url()","navigate()","new()","new()","on_click_script()","press_enter()","prevent_unhandled_alert_errors!()","process_confirm_alert_cmd()","process_deny_alert_cmd()","process_params()","refresh()","refresh_failsafe()","replay_macro()","rescue_headless_browser_errors_and_messages()","rescue_selenium_javascript_errors()","run_commands_and_handle_errors()","run_macro_command()","save_current_macro()","screenshot()","send_jquery_autotype_if_undefined()","send_jquery_if_undefined()","send_jquery_style_if_undefined()","send_on_click_if_undefined()","send_param()","send_static_script()","set_firefox_binary_path!()","setup_headless_env()","setup_headless_env()","start_driver()","start_headless()","start_running_macro()","sync_scripts()","transform_params()","turn_macro_recording_off()","turn_macro_recording_on()","update_macro()","url_is_really_url?()","valid_commands_list()","wait_until_document_is_ready()","gemfile","gemfile.lock","readme","install.sh","jquery.autotype.js","jquery.js","jquery.style.js","style.css"],"longSearchIndex":["alerthelpers","driverhelpers","headlessbrowser","headlessbrowsererror","headlessbrowsermessage","macrohelpers","macrorunner","routehelpers","routes","routesinit","macrohelpers#add_macro_to_current_macro()","macrohelpers#add_to_current_macro()","macrohelpers#all_macros()","driverhelpers#click_coords()","driverhelpers#click_selector()","alerthelpers#confirm_alert()","routesinit::connect_to_firefox_with_timeout()","macrohelpers#continue_macro_run()","macrorunner#continue_running_macro()","macrohelpers#db()","routehelpers#default_screenshot()","macrohelpers#delete_macro()","alerthelpers#deny_alert()","driverhelpers#driver_has_current_page?()","macrohelpers#edit_macro()","driverhelpers#ensure_current_page_exists()","driverhelpers#ensure_element_is_selected()","routehelpers#ensure_params_contains_a_command()","driverhelpers#enter_text()","driverhelpers#error_out()","routehelpers#execute_commands_and_return_screenshot()","macrorunner#expand_macro_into_running_command()","driverhelpers#find_element_with_selector()","headlessbrowser::headless_with_customization()","macrohelpers::included()","routehelpers#instructions_for_manually_handling_alert()","macrohelpers#macro_content_is_valid?()","macrohelpers#macro_update_error_msg()","headlessbrowser#make_hash_keys_symbols()","headlessbrowser#make_url()","driverhelpers#navigate()","driverhelpers::new()","headlessbrowser::new()","driverhelpers#on_click_script()","driverhelpers#press_enter()","routehelpers#prevent_unhandled_alert_errors!()","headlessbrowser#process_confirm_alert_cmd()","headlessbrowser#process_deny_alert_cmd()","headlessbrowser#process_params()","driverhelpers#refresh()","driverhelpers#refresh_failsafe()","macrohelpers#replay_macro()","routehelpers#rescue_headless_browser_errors_and_messages()","routehelpers#rescue_selenium_javascript_errors()","routehelpers#run_commands_and_handle_errors()","macrorunner#run_macro_command()","macrohelpers#save_current_macro()","headlessbrowser#screenshot()","driverhelpers#send_jquery_autotype_if_undefined()","driverhelpers#send_jquery_if_undefined()","driverhelpers#send_jquery_style_if_undefined()","driverhelpers#send_on_click_if_undefined()","headlessbrowser#send_param()","driverhelpers#send_static_script()","headlessbrowser::set_firefox_binary_path!()","routehelpers#setup_headless_env()","routesinit::setup_headless_env()","headlessbrowser::start_driver()","headlessbrowser::start_headless()","macrorunner#start_running_macro()","driverhelpers#sync_scripts()","headlessbrowser#transform_params()","macrohelpers#turn_macro_recording_off()","macrohelpers#turn_macro_recording_on()","macrohelpers#update_macro()","headlessbrowser#url_is_really_url?()","headlessbrowser#valid_commands_list()","headlessbrowser#wait_until_document_is_ready()","","","","","","","",""],"info":[["AlertHelpers","","AlertHelpers.html","","<p>Helpers for some routes relating to selenium alert handling\n<p>If an alert/confirm/prompt is raised in Selenium …\n"],["DriverHelpers","","DriverHelpers.html","","<p>Included by lib/headless_browser.rb\n"],["HeadlessBrowser","","HeadlessBrowser.html","","<p>Define a class which loads a headless Firefox browser using selenium\n"],["HeadlessBrowserError","","HeadlessBrowserError.html","","<p>custom error class for the headless browser\n"],["HeadlessBrowserMessage","","HeadlessBrowserMessage.html","","<p>use raise / rescue to pass around generic messages as well\n"],["MacroHelpers","","MacroHelpers.html","",""],["MacroRunner","","MacroRunner.html","","<p>only one macro is run at a time\n"],["RouteHelpers","","RouteHelpers.html","","<p>The RouteHelpers module provides a bunch of useful methods to Routes\n<p>It is required from lib/sinatra_routes.rb …\n"],["Routes","","Routes.html","",""],["RoutesInit","","RoutesInit.html","",""],["add_macro_to_current_macro","MacroHelpers","MacroHelpers.html#method-i-add_macro_to_current_macro","(name)","<p>macro nesting\n"],["add_to_current_macro","MacroHelpers","MacroHelpers.html#method-i-add_to_current_macro","(params_obj)","<p>saves params to the CurrentMacro list\n"],["all_macros","MacroHelpers","MacroHelpers.html#method-i-all_macros","()","<p>provides a list of macro objects which is displayed by root.erb\n"],["click_coords","DriverHelpers","DriverHelpers.html#method-i-click_coords","(x, y)","<p>Click x,y coordinates on the page\n"],["click_selector","DriverHelpers","DriverHelpers.html#method-i-click_selector","(selector)","<p>Click an element on the page based on a CSS selector No front-end\nconnection yet exists for this\n"],["confirm_alert","AlertHelpers","AlertHelpers.html#method-i-confirm_alert","()","<p>Accepts an alert, and enters text if needed (i.e. for a prompt) This is the\nresponse to the /confirm_alert …\n"],["connect_to_firefox_with_timeout","RoutesInit","RoutesInit.html#method-c-connect_to_firefox_with_timeout","(num_seconds)","<p>try and connect to firefox, but don&#39;t hang too long upon failure\n"],["continue_macro_run","MacroHelpers","MacroHelpers.html#method-i-continue_macro_run","()",""],["continue_running_macro","MacroRunner","MacroRunner.html#method-i-continue_running_macro","()","<p>responds to /continue_macro_run runs the next command in the\nRoutes::RunningCommand sequence\n"],["db","MacroHelpers","MacroHelpers.html#method-i-db","()",""],["default_screenshot","RouteHelpers","RouteHelpers.html#method-i-default_screenshot","(message)","<p>What to show if there is no new screenshot\n"],["delete_macro","MacroHelpers","MacroHelpers.html#method-i-delete_macro","(params_obj)","<p>content for /macro_delete route\n"],["deny_alert","AlertHelpers","AlertHelpers.html#method-i-deny_alert","()","<p>Denies an alert This is the response to the /deny_alert route The command\nis eventually forwarded to …\n"],["driver_has_current_page?","DriverHelpers","DriverHelpers.html#method-i-driver_has_current_page-3F","()","<p>Check if the driver is visiting any page\n"],["edit_macro","MacroHelpers","MacroHelpers.html#method-i-edit_macro","(params_obj)","<p>content for /macro_edit route\n"],["ensure_current_page_exists","DriverHelpers","DriverHelpers.html#method-i-ensure_current_page_exists","()","<p>unless there&#39;s a current page, raise an error and delete any remnant\nscreenshot\n"],["ensure_element_is_selected","DriverHelpers","DriverHelpers.html#method-i-ensure_element_is_selected","()","<p>Raise an error unless window.lastSelectedElement is set\n"],["ensure_params_contains_a_command","RouteHelpers","RouteHelpers.html#method-i-ensure_params_contains_a_command","(params_obj)","<p>If the params are empty (i.e. the browser goes to “localhost:4567”) prevent\nany screenshot …\n"],["enter_text","DriverHelpers","DriverHelpers.html#method-i-enter_text","(text)","<p>Enter text in the currently selected input\n"],["error_out","DriverHelpers","DriverHelpers.html#method-i-error_out","(text)","<p>stop processing commands, refresh the firefox javascript state, and raise\nan error\n"],["execute_commands_and_return_screenshot","RouteHelpers","RouteHelpers.html#method-i-execute_commands_and_return_screenshot","(params_obj)","<p>execute commands on the headless browser by interpreting the params Some\ncommand raise a HeadlessBrowserError …\n"],["expand_macro_into_running_command","MacroRunner","MacroRunner.html#method-i-expand_macro_into_running_command","(current_command)",""],["find_element_with_selector","DriverHelpers","DriverHelpers.html#method-i-find_element_with_selector","(selector)","<p>Given a CSS selector, find an element on the page and return it as a\nSelenium::WebDriver::Element This …\n"],["headless_with_customization","HeadlessBrowser","HeadlessBrowser.html#method-c-headless_with_customization","()",""],["included","MacroHelpers","MacroHelpers.html#method-c-included","(base)",""],["instructions_for_manually_handling_alert","RouteHelpers","RouteHelpers.html#method-i-instructions_for_manually_handling_alert","(text)","<p>present instructions to the user so they can handle an alert\n"],["macro_content_is_valid?","MacroHelpers","MacroHelpers.html#method-i-macro_content_is_valid-3F","(macro_content)",""],["macro_update_error_msg","MacroHelpers","MacroHelpers.html#method-i-macro_update_error_msg","(msg)",""],["make_hash_keys_symbols","HeadlessBrowser","HeadlessBrowser.html#method-i-make_hash_keys_symbols","(hash)","<p>Takes a hash and tries to convert all its keys to symbols. Will throw an\nerror if this is not possible. …\n"],["make_url","HeadlessBrowser","HeadlessBrowser.html#method-i-make_url","(txt)","<p>Turns “gmail” into “gmail.com”, for example\n"],["navigate","DriverHelpers","DriverHelpers.html#method-i-navigate","(url)","<p>Send the browser to a web page\n"],["new","DriverHelpers","DriverHelpers.html#method-c-new","(driver)",""],["new","HeadlessBrowser","HeadlessBrowser.html#method-c-new","(headless_env, driver)","<p>HeadlessBrowser initializer\n"],["on_click_script","DriverHelpers","DriverHelpers.html#method-i-on_click_script","()","<p>a script&#39;s text, which can be sent to the client via execute_script\nPractically, this stores a client-side …\n"],["press_enter","DriverHelpers","DriverHelpers.html#method-i-press_enter","()","<p>to submit a form containing the selected input\n"],["prevent_unhandled_alert_errors!","RouteHelpers","RouteHelpers.html#method-i-prevent_unhandled_alert_errors-21","()","<p>can&#39;t wait for selenium to throw an error about alerts because at that\npoint the error can no longer …\n"],["process_confirm_alert_cmd","HeadlessBrowser","HeadlessBrowser.html#method-i-process_confirm_alert_cmd","(text)","<p>If there&#39;s a pending alert, confirm it (possibly send it text as well)\n"],["process_deny_alert_cmd","HeadlessBrowser","HeadlessBrowser.html#method-i-process_deny_alert_cmd","()","<p>If there&#39;s a pending alert, deny it\n"],["process_params","HeadlessBrowser","HeadlessBrowser.html#method-i-process_params","(params_obj)","<p>Interpret parameters from routes and run commands accordingly\n"],["refresh","DriverHelpers","DriverHelpers.html#method-i-refresh","()","<p>Refresh the page using Javascript\n"],["refresh_failsafe","DriverHelpers","DriverHelpers.html#method-i-refresh_failsafe","()","<p>Refresh the page using selenium&#39;s API in case of halting Javascript\nerrors\n"],["replay_macro","MacroHelpers","MacroHelpers.html#method-i-replay_macro","(params_obj)","<p>content for /macro_play route\n"],["rescue_headless_browser_errors_and_messages","RouteHelpers","RouteHelpers.html#method-i-rescue_headless_browser_errors_and_messages","(&blk)","<p>rescue HeadlessBrowserError and HeadlessBrowserMessages by displaying the\nmessage and displaying the …\n"],["rescue_selenium_javascript_errors","RouteHelpers","RouteHelpers.html#method-i-rescue_selenium_javascript_errors","(&blk)","<p>Run a block of code and handle the case when Selenium throws an error When\nrescuing these errors, a  …\n"],["run_commands_and_handle_errors","RouteHelpers","RouteHelpers.html#method-i-run_commands_and_handle_errors","(params_obj)","<p>runs the commands detailed in the params. takes a screenshot or returns the\nmost recent screenshot, depending …\n"],["run_macro_command","MacroRunner","MacroRunner.html#method-i-run_macro_command","(macro_name, current_command)","<p>Runs command and sets up instance variables for the root view if it is a\nnested macro, expand it into …\n"],["save_current_macro","MacroHelpers","MacroHelpers.html#method-i-save_current_macro","(given_params)","<p>content for /macro_save route\n"],["screenshot","HeadlessBrowser","HeadlessBrowser.html#method-i-screenshot","()","<p>saves a screenshot to “public/screenshot.jog”\n"],["send_jquery_autotype_if_undefined","DriverHelpers","DriverHelpers.html#method-i-send_jquery_autotype_if_undefined","()","<p>Sends jquery autotype unless the page already defines $.fn.autotype\n"],["send_jquery_if_undefined","DriverHelpers","DriverHelpers.html#method-i-send_jquery_if_undefined","()","<p>Sends jQuery unless the page already defines jQuery\n"],["send_jquery_style_if_undefined","DriverHelpers","DriverHelpers.html#method-i-send_jquery_style_if_undefined","()","<p>This jquery plugin assists in setting styles with the !important tag\n"],["send_on_click_if_undefined","DriverHelpers","DriverHelpers.html#method-i-send_on_click_if_undefined","()","<p>TODO figure out if this should be sent every request or not: Currently it\n*<strong>does</strong>* because the check is …\n"],["send_param","HeadlessBrowser","HeadlessBrowser.html#method-i-send_param","(name, val)","<p>Run the command indicated by a particular param\n"],["send_static_script","DriverHelpers","DriverHelpers.html#method-i-send_static_script","(path)","<p>Sends a static script such as jquery\n"],["set_firefox_binary_path!","HeadlessBrowser","HeadlessBrowser.html#method-c-set_firefox_binary_path-21","()","<p>lib/firefox is a symlink to firefox-sdk/bin/firefox\n"],["setup_headless_env","RouteHelpers","RouteHelpers.html#method-i-setup_headless_env","()","<p>don&#39;t wait a full minute before raising an error if Firefox is\nunresponsive\n"],["setup_headless_env","RoutesInit","RoutesInit.html#method-c-setup_headless_env","()","<p>call methods in lib/headless_browser to lauch headless &amp; firefox The\nRoutes::Browser constant is …\n"],["start_driver","HeadlessBrowser","HeadlessBrowser.html#method-c-start_driver","()","<p>Create a firefox driver that can be passed to HeadlessBrowser.new\n"],["start_headless","HeadlessBrowser","HeadlessBrowser.html#method-c-start_headless","()","<p>Create a headless environment that can be passed to HeadlessBrowser.new\n"],["start_running_macro","MacroRunner","MacroRunner.html#method-i-start_running_macro","(macro_name, list_of_command_hashes)","<p>responds to /macro_run route runs the first command in the sequence on the\nclient side, a loop is set …\n"],["sync_scripts","DriverHelpers","DriverHelpers.html#method-i-sync_scripts","()","<p>send a bunch of scripts to the client\n"],["transform_params","HeadlessBrowser","HeadlessBrowser.html#method-i-transform_params","(params_obj)","<p>transform the params object. makes the params keys symbols and prepares the\n“click_coords” …\n"],["turn_macro_recording_off","MacroHelpers","MacroHelpers.html#method-i-turn_macro_recording_off","(given_params)","<p>content for /macro_off route\n"],["turn_macro_recording_on","MacroHelpers","MacroHelpers.html#method-i-turn_macro_recording_on","(given_params)","<p>content for /macro_on route\n"],["update_macro","MacroHelpers","MacroHelpers.html#method-i-update_macro","(params_obj)","<p>content for /macro_update route\n"],["url_is_really_url?","HeadlessBrowser","HeadlessBrowser.html#method-i-url_is_really_url-3F","(url)","<p>A pretty lenient check to see if a url is valid\n"],["valid_commands_list","HeadlessBrowser","HeadlessBrowser.html#method-i-valid_commands_list","()",""],["wait_until_document_is_ready","HeadlessBrowser","HeadlessBrowser.html#method-i-wait_until_document_is_ready","()","<p>don&#39;t send screenshots too early.\n"],["Gemfile","","Gemfile.html","","<p>source &#39;rubygems.org&#39;\n<p>gem &#39;headless&#39; gem &#39;selenium-webdriver&#39; gem\n&#39;sinatra&#39; …\n"],["Gemfile.lock","","Gemfile_lock.html","","<p>GEM\n\n<pre>remote: http://rubygems.org/\nspecs:\n  activesupport (4.2.7)\n    i18n (~&gt; 0.7)\n    json (~&gt; 1.7, &gt;= ...</pre>\n"],["README","","README_md.html","","<p>Installation:\n<p><code>sh install.sh</code>\n<p><code>bundle</code>\n"],["install.sh","","install_sh.html","","<p>#!/bin/bash\n<p># Tell the user what this script does. Sleep 5 seconds while they decide to\nproceed or not …\n"],["jquery.autotype.js","","public/jquery_autotype_js.html","","\n<pre>jQuery.autotype - Simple, accurate, typing simulation for jQuery\n\nversion 0.5.0\n\nhttp://michaelmonteleone.net/projects/autotype ...</pre>\n"],["jquery.js","","public/jquery_js.html","","\n<pre>! jQuery v2.2.5-pre | (c) jQuery Foundation | jquery.org/license</pre>\n<p>!function(a,b){“object”==typeof …\n"],["jquery.style.js","","public/jquery_style_js.html","","<p>(function($) {\n\n<pre>if ($.fn.style) {\n  return;\n}\n\n// Escape regex chars with \\\nvar escape = function(text) ...</pre>\n"],["style.css","","public/style_css.html","","\n<pre class=\"ruby\"><span class=\"ruby-constant\">Body</span> <span class=\"ruby-keyword\">and</span> <span class=\"ruby-constant\">HTML</span>\n</pre>\n<p>body, html {\n\n<pre>height: 100%; width: 100%;\nbackground-color: black;\ncolor: lightgreen;</pre>\n"]]}}