## Simple api client of [readability](http://www.readability.com)
not ready to use

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
```

or in your code

``` ruby

Readit::Config.consumer_key = some_key
Readit::Config.consumer_secret = some_value
```

### API use
``` ruby 

@api = Readit::API.new 'access_token','access_token_secret'

# get user info
@api.me
# get all bookmarks, result will be a hash array
@api.bookmarks
# get one artile by article_id
@api.article 'article_id'
# add bookmark
@api.bookmark :url=>'http://some_article_url.html'
# get bookmark by bookmark_id
@api.bookmarks :bookmark_id => some_bookmark_id
```

