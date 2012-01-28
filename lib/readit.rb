require "readit/version"
require 'multi_json'
require 'oauth'
# plugin railtie hook when using rails
require 'readit/railtie' if defined?(Rails)

module Readit

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

	end

	class API
		# Create a new Readit API client
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

		SITE_URL = 'https://www.readability.com/'

		# Retrieve the base API URI - information about subresources.
		# /
		def resource_info
			request(:get,'/')
		end

		# Retrieve a single Article, including its content. 
		# /articles/{article_id}
		def article(article_id)
			request(:get,"/articles/#{article_id}")
		end

		# Retrieve the bookmarks collection. Automatically filtered to the current user.
		# bookmark_id support
		#
		# /bookmarks?
		# archive
		# favorite
		# domain
		# added_since
		# added_until&
		# opened_since
		# opened_until&
		# archived_since&
		# archived_until&
		# favorited_since&
		# favorited_until&
		# updated_since&
		# updated_until&
		# order&
		# page&
		# per_page&
		# exclude_accessibility&
		# only_deleted
		#
		# /bookmarks/{bookmark_id}
		def bookmarks(args={})
			if args[:bookmark_id] and args[:bookmark_id]!=''
				request(:get,"/bookmarks/#{args[:bookmark_id]}")
			else
				params = args.map{|k,v| "#{k}=#{v}"}.join('&')
				request(:get,'/bookmarks',args)['bookmarks']
			end
		end

		# Add a bookmark. Returns 202 Accepted, meaning that the bookmark has been added but no guarantees are made as 
		# to whether the article proper has yet been parsed.
		#
		# favorite 0 or 1
		# archive 0 or 1
		def bookmark(args={})
			request(:post,'/bookmarks',args)
		end

		# Update a bookmark. Returns 200 on successful update.
		# /bookmarks/{bookmark_id}
		# favorite 0 or 1
		# archive 0 or 1
		def update_bookmark(bookmark_id,args={})
			request(:post,"/bookmarks/#{bookmark_id}",args)
		end

		# archive a bookmark by id
		def archive(bookmark_id)
			update_bookmark(bookmark_id,:archive=>1)
		end

		# favorite a bookmark by id
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
		def delete_bookmark(bookmark_id)
			request(:delete,"/bookmarks/#{bookmark_id}")
		end

		# Retrieve the contributions collection, which is a set of payments by a user to a specific domain. Automatically filtered to the current user.
		#
		# /contributions?since&until&domain&page&per_page
		def contributions(args={})
			request(:get,"/contributions",args)
		end

		# Retrieve the current user's information.
		# /users/_current
		def me
			request(:get,"/users/_current")
		end

		private 
		def request(method,url,args={})
			consumer = ::OAuth::Consumer.new(Readit::Config.consumer_key,Readit::Config.consumer_secret,:site=>SITE_URL)
			atoken = ::OAuth::AccessToken.new(consumer, @access_token, @access_token_secret)
			#response = client.send(method,"/api/rest/v1#{url}",args.merge!('oauth_token'=>@access_token,'oauth_token_secret'=>'5VEnMNPr7Q4393wxAYdnTWnpWwn7bHm4','oauth_consumer_key'=>'lidongbin','oauth_consumer_secret'=>'gvjSYqH4PLWQtQG8Ywk7wKZnEgd4xf2C'))
			response = atoken.send(method,"/api/rest/v1#{url}",args)
			if response.body==nil or response.body==''
				{:status => response.code}
			else
				MultiJson.decode response.body
			end
		end

	end
end
