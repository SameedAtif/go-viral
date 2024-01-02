# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "2.0"
Rails.application.config.assets.precompile += %w( jquery.js )
Rails.application.config.assets.precompile += %w( channels/appearance_channel )
Rails.application.config.assets.precompile += %w( channels/consumer )
Rails.application.config.assets.precompile += %w( channels/index )

Rails.application.config.assets.precompile += %w( views/gigs/form )
Rails.application.config.assets.precompile += %w( views/gigs/manage_gigs )

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
