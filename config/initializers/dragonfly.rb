require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret "b5a4fd4e3e4d85a5553d125bdb5ece7c3e84d1018ee58c72504f451b689b95e7"

  url_format "/media/:job/:name"

  datastore :file,
    root_path: Rails.root.join('public/system/dragonfly', Rails.env),
    server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
