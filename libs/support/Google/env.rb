#Project gems
require 'cucumber'
require 'watir'
require 'magic_encoding'
require 'date'

#File dependencies
require 'support/Google/hooks'            # Common libs

require 'utils/Utils'                     # Common libs
require 'utils/EditFile'                  # Common libs

# start browser
client = Selenium::WebDriver::Remote::Http::Default.new
client.read_timeout = 90

case ENV['BROWSER']
  when 'ie'
    browser = Watir::Browser.new :ie, :http_client => client
  when 'ff'
    browser = Watir::Browser.new :ff
  when 'chrome'
    browser = Watir::Browser.new :chrome
  else
    browser = Watir::Browser.new :ie, :http_client => client 
end

$URL = 'http://www.google.com.br'
browser.goto $URL
browser.window.maximize
$browser = browser