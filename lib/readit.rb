require "readit/version"
require 'multi_json'
require 'oauth'
require 'uri'
require 'hashie'
require 'net/http'
# plugin railtie hook when using rails
require 'readit/railtie' if defined?(Rails)

module Readit

  SITE_URL = 'https://www.readability.com/'

  class ReaditError < StandardError;end

  module Config

    def self.consumer_key
      @@consumer_key
    end

    def self.consumer_key=(val)
      @@consumer_key = val
    end

    def self.consumer_secret
      @@consumer_secret
    end

    def self.consumer_secret=(val)
      @@consumer_secret = val
    end

    def self.parser_token
      @@parser_token
    end

    def self.parser_token=(val)
      @@parser_token = val
    end

  end

  class Parser
    def initialize(parser_token = Readit::Config.parser_token)
      @parser_token = parser_token
      raise ReaditError.new('please set parser token before use') unless @parser_token
    end

    def parse(url)
      uri = URI.parse("#{SITE_URL}api/content/v1/parser?token=#{@parser_token}&url=#{URI.escape(url)}")
      http = Net::HTTP.new(uri.host, uri.port)
      # using https
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      # create request
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      Hashie::Mash.new MultiJson.decode(response.body)
    end
  end

  class API
    # initializer if creating a new Readit API client
    # @param access_token access_token of user
    # @param access_token_secret access_token_secret of user
    def initialize(access_token='',access_token_secret='')
      if access_token == '' or access_token_secret == ''
        raise ReaditError.new('have to provide access_token and access_token_secret')
      end
      if Readit::Config.consumer_key=='' or Readit::Config.consumer_secret==''
        raise ReaditError.new('please set Readit::Config.consumer_key or Readit::Config.consumer_secret first')
      end
      @access_token = access_token
      @access_token_secret = access_token_secret
    end

    attr_reader :access_token

    # Retrieve the base API URI - information about subresources.
    def resource_info
      request(:get,'/')
    end

    # Retrieve a single Article, including its content.
    # api rest address: /articles/{article_id}
    # @param article_id the article_id
    def article(article_id)
      request(:get,"/articles/#{article_id}")
    end

    # Retrieve the bookmarks collection. Automatically filtered to the current user.
    # api rest address : /bookmarks? or /bookmarks/{bookmark_id}
    # @args support
    # bookmark_id (at most return one record)
    # archive
    # favorite
    # domain
    # added_since
    # added_until
    # opened_since
    # opened_until
    # archived_since
    # archived_until
    # favorited_since
    # favorited_until
    # updated_since
    # updated_until
    # order
    # page
    # per_page default 20,max 50
    # exclude_accessibility
    # only_deleted
    # ***** Special args *****
    # to get bookmarks meta infos
    # :include_meta => true
    # item_count=20 item_count_total=633 num_pages=32 page=1
    # bookmarks,meta = @api.bookmarks(:include_meta => true)
    def bookmarks(args={})
      if args[:bookmark_id] and args[:bookmark_id]!=''
        request(:get,"/bookmarks/#{args[:bookmark_id]}")
      else
        params = args.map{|k,v| "#{k}=#{v}"}.join('&')
        result = request(:get,"/bookmarks?#{URI.escape(params)}")
        args[:include_meta] ? [result.bookmarks,result.meta] : result.bookmarks
      end
    end

    # Add a bookmark. Returns 202 Accepted, meaning that the bookmark has been added but no guarantees are made as
    # to whether the article proper has yet been parsed.
    # @param args args to bookmark a url
    # url the address to bookmark
    # favorite 0 or 1
    # archive 0 or 1
    # Return example
    # success:
    # {:status => '202',:bookmark_id => '233444', :article_id => 't323r2'}
    # conflicts
    # {:status => '409'}
    def bookmark(args={})
      raise ReaditError.new('expect at lease a hash argument with key :url') unless args[:url]
      request(:post,'/bookmarks',args) do |response|
        Hashie::Mash.new({
          :status =>response.code,
          :bookmark_id=> ['202', '409'].include?(response.code) ? response["Location"].match(/bookmarks\/(.*)/)[1] : '',
          :article_id=> response.code== '202' ? response["X-Article-Location"].match(/articles\/(.*)/)[1] : ''})
      end
    end

    # Update a bookmark. Returns 200 on successful update.
    # api rest address : /bookmarks/{bookmark_id}
    # @param bookmark_id bookmark to update
    # @param args args to update the bookmark
    # favorite 0 or 1
    # archive 0 or 1
    def update_bookmark(bookmark_id,args={})
      request(:post,"/bookmarks/#{bookmark_id}",args)
    end

    # archive a bookmark by id
    # @param bookmark_id bookmark to archive
    def archive(bookmark_id)
      update_bookmark(bookmark_id,:archive=>1)
    end

    # favorite a bookmark by id
    # @param bookmark_id bookmark_id to favorite
    def favorite(bookmark_id)
      update_bookmark(bookmark_id,:favorite=>1)
    end

    # Remove a single bookmark from this user's history.
    # NOTE: THIS IS PROBABLY NOT WHAT YOU WANT. This is particularly for the case where a user accidentally bookmarks
    # something they have no intention of reading or supporting.
    # In almost all cases, you'll probably want to use archive by POSTing archive=1 to this bookmark.
    # If you use DELETE and this months bookmarks have not yet been tallied,
    # the site associated with this bookmark will not receive any contributions for this bookmark.
    # Use archive! It's better.
    # Returns a 204 on successful remove.
    # @param bookmark_id bookmark to delete
    def delete_bookmark(bookmark_id)
      request(:delete,"/bookmarks/#{bookmark_id}")
    end

    # Retrieve the contributions collection, which is a set of payments by a user to a specific domain. Automatically filtered to the current user.
    # api rest address : /contributions?since&until&domain&page&per_page
    def contributions(args={})
      request(:get,"/contributions",args)
    end

    # Retrieve the current user's information.
    # api rest address :/users/_current
    def me
      request(:get,"/users/_current")
    end

    # Retrieve all tags of current user
    # api rest address :/tags
    def all_tags
      request(:get,"/tags")
    end

    # add tags to one bookmark
    # api rest address POST :/bookmarks/{bookmark_id}/tags
    def add_tags(bookmark_id, tags_string)
      request(:post, "/bookmarks/#{bookmark_id}/tags",{ :tags => tags_string }).tags
    end

    # Retrieve all tags of one bookmark
    # api rest address GET :/bookmarks/{bookmark_id}/tags
    def tags(bookmark_id)
      request(:get, "/bookmarks/#{bookmark_id}/tags").tags
    end

    # remove tag info from bookmark
    # api rest address DELETE /bookmarks/{bookmark_id}/tags/{tag_id}
    def remove_tag(bookmark_id, tag_id)
      request(:delete, "/bookmarks/#{bookmark_id}/tags/#{tag_id}")
    end

    private
    def request(method,url,args={})
      consumer = ::OAuth::Consumer.new(Readit::Config.consumer_key,Readit::Config.consumer_secret,:site=>SITE_URL)
      atoken = ::OAuth::AccessToken.new(consumer, @access_token, @access_token_secret)
      #response = client.send(method,"/api/rest/v1#{url}",args.merge!('oauth_token'=>@access_token,'oauth_token_secret'=>'5VEnMNPr7Q4393wxAYdnTWnpWwn7bHm4','oauth_consumer_key'=>'lidongbin','oauth_consumer_secret'=>'gvjSYqH4PLWQtQG8Ywk7wKZnEgd4xf2C'))
      response = atoken.send(method,"/api/rest/v1#{url}",args)
      if block_given?
        yield response
      else
        hashie_response(response)
      end
    end

    def hashie_response(response)
      if response.body==nil or response.body==''
        Hashie::Mash.new({:status => response.code})
      else
        Hashie::Mash.new MultiJson.decode(response.body)
      end
    end

  end
end
