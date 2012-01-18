require "readit/version"
require 'multi_json'

module Readit

	class ReaditError < StandardError;end

	class API
		# Create a new Readit API client
		def initialize(access_token='')
			@access_token = access_token
		end

		attr_reader :access_token

		SITE_URL = 'https://www.readability.com/api/rest/v1'

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
		# /bookmarks?archive&favorite&domain&added_since&added_until&opened_since&opened_until&
		# archived_since&archived_until&favorited_since&favorited_until&updated_since&updated_until&
		# order&page&per_page&exclude_accessibility&only_deleted
		#
		# /bookmarks/{bookmark_id}
		def bookmarks(args={})
			if args[:bookmark_id] and args[:bookmark_id]!=''
				request(:get,"/bookmarks/#{args[:bookmark_id]}")
			else
				params = args.map{|k,v| "#{k}=#{v}"}.join('&')
				request(:get,'/bookmarks',params)
			end
		end

		# Add a bookmark. Returns 202 Accepted, meaning that the bookmark has been added but no guarantees are made as 
		# to whether the article proper has yet been parsed.
		#
		# /bookmarks?archive&favorite&domain&added_since&added_until&opened_since&opened_until&
		# archived_since&archived_until&favorited_since&favorited_until&updated_since&updated_until&
		# order&page&per_page&exclude_accessibility&only_deleted
		def add_bookmark(url,args={})
			request(:post,'/bookmarks',args)
		end

		# Update a bookmark. Returns 200 on successful update.
		# /bookmarks/{bookmark_id}
		def update_bookmark(bookmark_id,args={})
			request(:post,"/bookmarks/#{bookmark_id}",args)
		end

		def archive(bookmark_id)
			update_bookmark(bookmark_id,:archive=>1)
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
			response = @client.send method,url,args
			MultiJson.decode response
		end

		def client
			@client ||= (Faraday.new(:url => SITE_URL) do |builder|
				# or, use shortcuts:
				builder.request  :url_encoded
				builder.response :logger
				builder.adapter  :net_http
			end)
		end

	end
  # Your code goes here...
end
