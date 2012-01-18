require 'spec_helper'

describe "Readit::API" do

  it "should get all bookmarks" do
		api = Readit::API.new ''
		#api.me
		api.bookmarks
  end

end

