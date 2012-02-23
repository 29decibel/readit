require_relative '../../lib/readit'
require 'time'

When /^call bookmarks with option (\w+) ((\w|-)+)$/ do |option_name,option_value,not_use|
  @bookmarks = @client.bookmarks option_name.to_sym => option_value
end

When /^call bookmarks$/ do
  @bookmarks = @client.bookmarks
end

Then /^got (\d+) bookmarks back$/ do |bookmarks_count|
  @bookmarks.count.should == bookmarks_count.to_i
end

Then /^got the first bookmark's date should less than ((\w+|-)+)/ do |date,not_use|
  Time.parse(@bookmarks.first.date_added).should <= Time.parse(date)
end


def plog
  puts "============================"
  yield
  puts "============================"
end

