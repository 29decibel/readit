require 'spec_helper'

describe "Readit::API" do
	before do
		# load consumer infos
    consumer_info = YAML.load_file(File.join(File.dirname(__FILE__),'../readability.yml'))["development"]
		puts consumer_info
		Readit::Config.consumer_key = consumer_info['consumer_key']
		Readit::Config.consumer_secret = consumer_info['consumer_secret']
		@api = Readit::API.new 'zQuzAzVW4Ark7VZvm2','5VEnMNPr7Q4393wxAYdnTWnpWwn7bHm4'
	end

  it "should get user infos" do
		#@api.me.should_not == nil
  end

	it "should get user's bookmarks" do
		#@api.bookmarks.should_not == nil
	end

	it "should add bookmark" do
		# url = 'http://gigix.thoughtworkers.org/2012/1/16/why-should-you-start-career-from-professional-services'
		# resp = @api.add_bookmark :url=>url
		# puts resp.inspect
		# resp.should_not == nil
	end

	it "should get the article content" do
		article = @api.article 'eg60dxbv'
		puts article
		article.should_not == nil
	end

end

