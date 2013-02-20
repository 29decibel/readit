require 'spec_helper'
require 'time'

describe "Readit::API",:vcr do
  before do
    # load consumer infos
    tokens = YAML.load_file(File.join(File.dirname(__FILE__),'../readability.yml'))["development"]
    Readit::Config.consumer_key = tokens['consumer_key']
    Readit::Config.consumer_secret = tokens['consumer_secret']
    @api = Readit::API.new tokens['oauth_token'],tokens['oauth_token_secret']
  end

  let :bookmarks do
    @bms = @api.bookmarks
  end

  let :bookmark_ids do
    bookmarks.map{|a| a['id']}
  end

  it "can fetch all tags information of current user" do
    tags = @api.all_tags
    tags.count.should > 0
  end

  it "can add tags to one bookmark" do
    bookmark_id = bookmark_ids.first
    tags = @api.add_tags bookmark_id, "book,movie,music"
    tags.count.should == 3
  end

  it "can fetch tags of one bookmark" do
    bookmark_id = bookmark_ids.first
    tags = @api.tags bookmark_id
    tags.count.should == 3
  end

  it "can remove tag info of one bookmark by tag id" do
    bookmark_id = bookmark_ids.first
    tags = @api.tags bookmark_id
    @api.remove_tag bookmark_id,tags.first.id
    @api.tags(bookmark_id).count.should == 2
  end


end
