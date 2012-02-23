require 'readit'

Given /^the user's (\w+) and the (\w+)$/ do |access_token, access_secret|
  @access_token  = access_token
  @access_secret = access_secret
end

Given /^set (\w+) and (\w+) to Readit::Config$/ do |consumer_key,consumer_secret|
  Readit::Config.consumer_key = consumer_key
  Readit::Config.consumer_secret = consumer_secret
end

When /^call new of Readit$/ do
  @client = Readit::API.new @access_token,@access_secret
end

Then /^get the api client$/ do
  @client != nil
end

When /^call bookmarks with option per_page (\d+)$/ do |per_page|
  @bookmarks = @client.bookmarks :per_page => per_page
end

Given /^the readit api client$/ do
  consumer_info = YAML.load_file(File.join(File.dirname(__FILE__),'../../readability.yml'))["development"]
  Readit::Config.consumer_key = consumer_info['consumer_key']
  Readit::Config.consumer_secret = consumer_info['consumer_secret']
  @client = Readit::API.new "zQuzAzVW4Ark7VZvm2","5VEnMNPr7Q4393wxAYdnTWnpWwn7bHm4"
end

When /^call bookmarks$/ do
  @bookmarks = @client.bookmarks
end

Then /^got (\d+) bookmarks back$/ do |bookmarks_count|
  @bookmarks.count == bookmarks_count
end

