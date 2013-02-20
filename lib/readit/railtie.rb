module Readit
  class Railtie < Rails::Railtie
    config.after_initialize do
      if File.exists?('config/readability.yml')
        consumer_info = YAML.load_file(File.join(Rails.root.to_s, 'config', 'readability.yml'))[Rails.env || "development"]
        if consumer_info
          Readit::Config.consumer_key = consumer_info["consumer_key"]
          Readit::Config.consumer_secret = consumer_info["consumer_secret"]
          Readit::Config.parser_token = consumer_info["parser_token"]
        else
          Rails.logger.warn "Please check your config/readability.yml file, no consumer_key and consumer_sercret under #{Rails.env} found"
        end
      else
        Rails.logger.warn "Please provide consumer_key and consumer_sercret on config/readability.yml file"
      end
    end
  end
end
