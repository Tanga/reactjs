require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module Reactjs
  class Application < Rails::Application
    config.react.variant = :development
    config.react.addons = true
  end
end
