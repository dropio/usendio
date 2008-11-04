RAILS_GEM_VERSION = '2.1.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.load_paths += %W( #{RAILS_ROOT}/lib )
  config.time_zone = 'UTC'
  config.action_controller.session = {
    :session_key => '_usendio_session',
    :secret      => '6587ab668038b43a2e3799535758f4e07d4d753c130da2e8113e0270972e9f95ffe6840d50110c602572cfb2e0637eab1ebc5045361ea817ebdf269bdf3336ac'
  }
end

include Dropio
api_config = YAML.load(File.open(File.join(RAILS_ROOT,"config","api.yml")))
Dropio.api_key = api_config["dropio"]["api_key"]