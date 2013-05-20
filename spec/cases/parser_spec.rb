require 'spec_helper'
require 'time'

describe "Readit::Parser",:vcr do
  before do
    # load consumer infos
    tokens = YAML.load_file(File.join(File.dirname(__FILE__),'../readability.yml'))["development"]
    Readit::Config.parser_token = tokens['parser_token']
    @parser = Readit::Parser.new tokens['parser_token']
    @url = "http://statico.github.com/vim.html"
  end

  it "should return parsed article cotents" do
    article = @parser.parse @url
    article.title.should_not == nil
    article.content.should_not == nil
    article.content.length.should > 0
  end

  it "api confidence should return with a confidence" do
    confidence_info = @parser.confidence(@url)
    confidence_info.url.should_not be_empty
    confidence_info.confidence.should > 0
  end
end
