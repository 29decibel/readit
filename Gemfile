source 'http://rubygems.org'
gem 'multi_json'

group :development, :test do
  gem 'rspec'
  # Testing infrastructure
  gem 'guard'
  gem 'guard-rspec'
  gem 'cucumber'
  gem 'vcr','2.0.1'
  gem 'webmock','~> 1.8.0', :require => false

  if RUBY_PLATFORM =~ /darwin/
    # OS X integration
    gem "ruby_gntp"
    gem "rb-fsevent", "~> 0.9.0"
  end
end
gem 'oauth'
gem 'hashie'


# Specify your gem's dependencies in readit.gemspec
gemspec
