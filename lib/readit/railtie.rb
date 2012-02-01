module Readit
  class Railtie < Rails::Railtie
    config.after_initialize do
      if File.exists?('config/readability.yml')
        consumer_info = YAML.load_file(File.join(Rails.root.to_s, 'config', 'readability.yml'))[Rails.env || "development"]
				if consumer_info
        	Readit::Config.consumer_key = consumer_info["consumer_key"]
        	Readit::Config.consumer_secret = consumer_info["consumer_secret"]
				end
      end
    end
  end
end
