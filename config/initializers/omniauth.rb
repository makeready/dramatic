Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_REST_API1'], ENV['TWITTER_REST_API2']
end