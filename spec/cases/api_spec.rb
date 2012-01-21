require 'spec_helper'

describe "Readit::API" do

  it "should get all bookmarks" do
		api = Readit::API.new 'zQuzAzVW4Ark7VZvm2','5VEnMNPr7Q4393wxAYdnTWnpWwn7bHm4'
		api.me.should_not == nil
		#api.bookmarks
  end

end

