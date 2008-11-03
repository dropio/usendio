RAILS_GEM_VERSION = '2.1.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.load_paths += %W( #{RAILS_ROOT}/lib )
  config.time_zone = 'UTC'
  config.action_controller.session = {
    :session_key => '_collabio_session',
    :secret      => '0d68389d814e9c4aae6c84e1302b5e93391d940264188e81223870ec02d1a511822e88d623845306bf67621dbca38c2b8aa9edf9357506269133aaa7c9b18bcc'
  }
end

api_config = YAML.load(File.open(File.join(RAILS_ROOT,"config","api.yml")))

include Dropio
Dropio.api_key = api_config["dropio"]["api_key"]
