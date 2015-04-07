Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0', namespace: "compgeo_#{Rails.env}" }
  database_url = ENV['DATABASE_URL']
  if database_url
    ActiveRecord::Base.establish_connection(database_url)
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0', namespace: "compgeo_#{Rails.env}" }
end
