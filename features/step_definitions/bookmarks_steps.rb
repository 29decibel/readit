require_relative '../../lib/readit'
require 'time'

Given /^get latest bookmarks$/ do
  @l_bookmarks = @client.bookmarks
end

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


Then /^got any number of bookmarks which marked favorite$/ do
  @bookmarks.select{|b| !b.favorite }.count.should == 0
end

When /^call bookmarks with bookmark_id of the lastest one$/ do
  b_id = @l_bookmarks.first.id
  @bookmark = @client.bookmarks :bookmark_id => b_id
  @bookmark.id.should == b_id
end

Then /^got one right bookmark with the same id$/ do
  @bookmark.should_not == nil
end

When /^call update_bookmark latest bookmark_id with options favorite (\d+)$/ do |favorite|
  @client.update_bookmark @bookmarks.first.id,:favorite=>1
end

Then /^got bookmark's favorite set to true$/ do
  @client.bookmarks.first.favorite.should == true
end

When /^call archive with bookmark_id$/ do
  @bookmark = @client.bookmarks.first
  @client.archive @bookmark.id
end

Then /^got bookmark's archive set to true$/ do
  @client.bookmarks.first.archive.should == true
end

When /^add bookmark with url (https?:\/\/[\S]+)$/ do |url|
  @add_bookmark_result = @client.bookmark :url=>url
end

Then /^got status ok$/ do
  @add_bookmark_result.status.should == '202'
end

When /^fetch the latest bookmark$/ do
  @last_bookmark = @client.bookmarks.first
end

Then /^got the bookmark with url (https?:\/\/[\S]+)$/ do |url|
  @last_bookmark.article.url.chop.should == url
end

When /^delete this new added bookmark$/ do
  @client.delete_bookmark @last_bookmark.id
end

Then /^the latesed bookmark which url is not (https?:\/\/[\S]+)$/ do |url|
  @last_bookmark.article.url.should_not == url
end


def plog
  puts "============================"
  yield
  puts "============================"
end

