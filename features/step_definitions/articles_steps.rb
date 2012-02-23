require_relative '../../lib/readit'

When /^get article info of the latest bookmark$/ do
  @article = @client.article(@last_bookmark.article.id)
end

Then /^get article's except and content info$/ do
  @article.content.length.should > 10
end

