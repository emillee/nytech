Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :developer unless Rails.env.production?
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET'], {:client_options => {:ssl => {:ca_file => "/usr/lib/ssl/certs/ca-certificates.crt"}}}
  provider :google_oauth2, ENV['GOOGLE_APP_ID'], ENV['GOOGLE_SECRET']
  provider :linkedin, ENV["LINKEDIN_KEY"], ENV["LINKEDIN_SECRET"], :scope => 'r_fullprofile r_emailaddress r_network', :fields => ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location", "connections"]
  provider :github, ENV["GITHUB_KEY"], ENV["GITHUB_SECRET"]
end