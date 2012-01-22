### Simple api client of [readability](http://www.readability.com)
not ready to use
### Configuration
#### Rails
config/readability.yml

``` ruby

development:
	consumer_key: some_key
	consumer_secret: some_secret

```

#### or in your code

``` ruby

Readit::Config.consumer_key = some_key
Readit::Config.consumer_secret = some_value

```

### API use
``` ruby 

@api = Readit::API.new 'access_token','access_token_secret'

# get user info
@api.me

# get all bookmarks
@api.bookmarks

# get one artile by article_id
@api.article 'article_id'

# add bookmark
@api.add_bookmark :url=>'http://some_article_url.html'

```

