# frozen_string_literal: true

require 'resolv-replace'
require 'sidekiq'

redis_config = Rails.application.config_for(:redis) || {}

redis = {
  url: ENV.fetch('REDIS_URL',
                 "redis#{redis_config['ssl'] ? 's' : ''}://#{redis_config['host']}:#{redis_config['port']}/#{redis_config['db']}")
}

redis_pass = redis_config['password']
redis[:password] = redis_pass if redis_pass.present?

Sidekiq.configure_server do |config|
  config.redis = redis
  config.average_scheduled_poll_interval = 15
end

Sidekiq.configure_client do |config|
  config.redis = redis
end

ActiveJob::Base.logger = Rails.logger
