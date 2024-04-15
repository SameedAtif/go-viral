# frozen_string_literal: true

Redis.current = Redis.new(
  url: ENV['REDIS_URL'] || ENV['REDIS_URL_SIDEKIQ'] || 'redis://127.0.0.1',
  port: ENV['REDIS_PORT_RAILS'] || 6379,
  db: ENV['REDIS_DB_RAILS'] || 1
)
