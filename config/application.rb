require File.expand_path('../boot', __FILE__)

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DocManager
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('app', 'services')

    config.assets.paths << Rails.root.join('vendor','assets','bower_components')
    config.assets.paths << Rails.root.join('vendor','assets','bower_components','bootstrap-sass-official','assets','fonts')

    config.assets.precompile << %r(.*.(?:eot|svg|ttf|woff)$)
  end
end
