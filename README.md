This is a Sinatra app with route definitions in `start_server.rb`

It requires `lib/headless_browser.rb`, which runs `headless` and `selenium-webdriver`.

This will not work out the box since it requires a custom firefox binary. Selenium currently works with Firefox 46, which is not the
newest version.

To install dependencies and set up the correct Firebox binary, run `install.sh`.

After this is done, run `ruby start_server.rb` and visit `localhost:4567?url=google` in the browser.


