require 'spec_helper'

describe "Readit::API" do
	before do
		Readit::Config.consumer_key = 'lidongbin'
		Readit::Config.consumer_secret = 'gvjSYqH4PLWQtQG8Ywk7wKZnEgd4xf2C'
	end

  it "should get all bookmarks" do
		api = Readit::API.new 'zQuzAzVW4Ark7VZvm2','5VEnMNPr7Q4393wxAYdnTWnpWwn7bHm4'
		api.me.should_not == nil
		#api.bookmarks
  end

end

