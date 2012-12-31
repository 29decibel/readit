begin
  require 'bundler/setup'
rescue LoadError
  puts 'Although not required, bundler is recommended for running the tests.'
end


require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!

  tokens = YAML.load_file(File.join(File.dirname(__FILE__),'./readability.yml'))["development"]
  tokens.values.each do |sv|
    c.filter_sensitive_data('<TOKENS>') { sv }
  end
end

RSpec.configure do |c|
  c.mock_with :rspec
  c.color_enabled = true
  # so we can use `:vcr` rather than `:vcr => true`;
  # in RSpec 3 this will no longer be necessary.
  c.treat_symbols_as_metadata_keys_with_true_values = true
end



require_relative '../lib/readit'
