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
    config.hosts << "35ac-98-169-39-240.ngrok.io"
    ShopifyAPI::Base.site = "https://#{ENV["SHOPIFY_API_KEY"]}:#{ENV["SHOPIFY_PASSWORD"]}@shopurotuning.myshopify.com/admin"
    ShopifyAPI::Base.api_version = '2021-01'
  end
end
