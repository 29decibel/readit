## Simple api client of [Readability](http://readability.com) [![Build Status](https://travis-ci.org/29decibel/readit.png)](https://travis-ci.org/29decibel/readit)  [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/29decibel/readit)

### Installation
```ruby

gem install readit
```
or in your rails gemfile

``` ruby

gem 'readit'
# or latest (recommend)
gem 'readit',:git=>'git@github.com:29decibel/readit.git'
```

### Configuration
#### Rails
config/readability.yml

``` ruby

development:
  consumer_key: some_key
  consumer_secret: some_secret
  parser_token: some_parser_token
```

or in your code

``` ruby

Readit::Config.consumer_key = some_key
Readit::Config.consumer_secret = some_value
Readit::Config.parser_token = some_parser_token
```

### API usage

#### Initialize api client
``` ruby

@api = Readit::API.new 'access_token','access_token_secret'
```

#### User info
```ruby
# get user info
@api.me
```

#### Bookmarks
```ruby
# get all bookmarks, result will be a hash array
@api.bookmarks
# get bookmarks along with meta info :
# item_count, item_count_total, num_pages, page
bookmarks,meta = @api.bookmarks(:include_meta => true)

# add bookmark
bookmark_info = @api.bookmark(:url=>'http://some_article_url.html')
# check bookmarked infos
# bookmark_info.bookmark_id
# bookmark_info.article_id

# get bookmark by bookmark_id
@api.bookmarks :bookmark_id => some_bookmark_id

# archive a bookmark
@api.archive some_bookmark_id

# favorite a bookmark
@api.favorite some_bookmark_id

# or you can just call update_bookmark to
# update a bookmark to favorited or archived
@api.update_bookmark bookmark_id,:favorite => 1,:archive => 0
```

#### Tags
```ruby
# get all tags of current user
@api.all_tags # [#<Hashie::Mash id=39086 text="rails">, #<Hashie::Mash id=39085 text="ruby">, #<Hashie::Mash id=39087 text="tag3">]

# add tags to one bookmark
@api.add_tags bookmark_id, "tag1,tag2,tag3"

# fetch all tags of one bookmark
@api.tags bookmark_id

# remove tag from one bookmark
@api.remove_tag bookmark_id, tag_id
```

#### Get Article
```ruby
# get one artile by article_id
@api.article 'article_id'

```

### Parser
```ruby
# create a parser client
@parser = Readit::Parser.new "some_parser_token"
# parse one url
@parser.parse some_url
# now you will get a object with title, content, etc.
```

### At last but not least
>Contributions are welcome!

