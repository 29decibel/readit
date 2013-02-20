require 'spec_helper'
require 'time'

describe "Readit::Parser",:vcr do
  before do
    # load consumer infos
    tokens = YAML.load_file(File.join(File.dirname(__FILE__),'../readability.yml'))["development"]
    Readit::Config.parser_token = tokens['parser_token']
    @parser = Readit::Parser.new tokens['parser_token']
  end

  it "should return parsed article cotents" do
    url = "http://statico.github.com/vim.html"
    article = @parser.parse url
    article.title.should_not == nil
    article.content.should_not == nil
    article.content.length.should > 0
  end
end
