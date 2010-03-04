ENV["RAILS_ENV"] ||= "cucumber"

require File.expand_path(File.dirname(__FILE__) + '/../../../config/environment')
require 'steam'
require 'test/unit'
# require 'rspec'

ENV['CLASSPATH'] = Dir["/opt/htmlunit-2.7/lib/*.jar"].join(':')
Steam.config[:html_unit][:java_path] = '/opt/htmlunit-2.7'

browser = Steam::Browser.create
World do
  Steam::Session::Rails.new(browser)
end

at_exit { browser.close }
