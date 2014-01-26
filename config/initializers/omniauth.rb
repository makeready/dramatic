# -*- encoding : utf-8 -*-
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_REST_API1'], ENV['TWITTER_REST_API2'],
    { 
      authorize_params: {force_login: 'true'} #DEMO MODE DEMO MODE DEMO MODE
    }
end
