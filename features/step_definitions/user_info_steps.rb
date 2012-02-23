require_relative '../../lib/readit'

When /^call me on api client$/ do
  @me = @client.me
end

Then /^get use infos$/ do
  @me.username.should == 'lidongbin'
end

