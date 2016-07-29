This is a Sinatra app with route definitions in `start_server.rb`

It requires `lib/headless_browser.rb`, which runs `headless` and `selenium-webdriver`.

This will not work out the box since it requires a custom firefox binary. Selenium currently works with Firefox 46, which is not the
newest version.

To install dependencies and set up the correct Firebox binary, run `install.sh`.

After this is done, run `ruby start_server.rb` and visit `localhost:4567?url=google` in the browser.

---

Usage:

Go to the website, http://localhost:4567

Then where it says "type website name" enter some url and submit that form

You will then see an image showing the result of visiting that url in the headless browser.

You can click around the page and see the effect.

To enter text, click on an input or textarea and then use the "send text to selected node" form.

If there are any bugs, hit the "refresh" button. 



