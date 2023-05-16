require_relative 'boot'

require 'rails/all'
require 'uri'
require 'net/http'
require 'openssl'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module UroTuningSaveCart
  class Application < Rails::Application

    Figaro.load
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.hosts << "e848-2600-8806-6403-3b00-c0aa-7266-2ea-9f85.ngrok-free.app"
    config.hosts << "urotuning.herokuapp.com"
    config.hosts << "saveyourcart.urotuning.com"
    
    ShopifyAPI::Base.site = "https://#{ENV["SHOPIFY_API_KEY"]}:#{ENV["SHOPIFY_PASSWORD"]}@shopurotuning.myshopify.com/admin"
    ShopifyAPI::Base.api_version = '2021-01'
  end
end
