require 'spec_helper'
require 'time'

describe "Readit::API",:vcr do
  before do
    # load consumer infos
    tokens = YAML.load_file(File.join(File.dirname(__FILE__),'../../readability.yml'))["development"]
    Readit::Config.consumer_key = tokens['consumer_key']
    Readit::Config.consumer_secret = tokens['consumer_secret']
    @api = Readit::API.new tokens['oauth_token'],tokens['oauth_token_secret']
  end

  let :bookmarks do
    @bms ||= @api.bookmarks
  end

  let :bookmark_ids do
    bookmarks.map{|a| a['id']}
  end

  it "should get user infos" do
    @api.me.should_not == nil
  end

  it "should get user's bookmarks" do
    bookmarks.should_not == nil
    bookmarks.count.should > 0
  end

  it "should add bookmark" do
    url = 'http://www.tripadvisor.com/Restaurant_Review-g297701-d1182615-Reviews-Cafe_Lotus-Ubud_Bali.html'
    resp = @api.bookmark :url=>url
    resp.should_not == nil
  end

  it "can get bookmark location when bookmarked a url" do
    url = 'http://www.jslib.org.cn/njlib_xsyj/201011/t20101130_98154.htm'
    resp = @api.bookmark :url => url
    puts resp.inspect
    resp.bookmark_id.should_not be_nil
    resp.article_id.should_not be_nil
  end

  it "should get the article content" do
    article = @api.article 'eg60dxbv'
    #puts article
    article.should_not == nil
  end

  it "should get the bookmark info by bookmark id" do
    bookmark = @api.bookmarks :bookmark_id=>bookmark_ids.first
    bookmark.should_not == nil
  end

  it "should get bookmarks according to added since" do
    bookmarks = @api.bookmarks(:added_until=>'2012-1-1',:per_page=>2)
    bookmarks.count.should > 0
    bookmarks.select{|b| Time.parse(b.date_added) > Time.parse('2012-1-1')}.count.should == 0
  end

  it "should update bookmark to favarite" do
    bm_id = bookmark_ids.first
    @api.favorite bm_id
    bookmark = @api.bookmarks :bookmark_id=>bm_id
    bookmark.should be_favorite
  end

  it "should update bookmark to archive" do
    bm_id = bookmark_ids.first
    @api.archive bm_id
    bookmark = @api.bookmarks :bookmark_id=>bm_id
    bookmark.should be_archive
  end

  it "should raise exception when call bookmark without url provide" do
    lambda { @api.bookmark }.should raise_error
  end


end

