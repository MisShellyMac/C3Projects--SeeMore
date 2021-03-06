require 'api_helpers'

class TwitterClient
  CLIENT = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV["TWITTER_API_KEY"]
    config.consumer_secret = ENV["TWITTER_API_SECRET"]
    config.access_token = ENV["TWITTER_ACCESS_TOKEN"]
    config.access_token_secret = ENV["TWITTER_TOKEN_SECRET"]
  end

  def self.user_search(search_term)
    prey = CLIENT.user_search(search_term)
    TwitterHelper.format_many_prey(prey)
  end

  def self.find_user(username)
    prey = CLIENT.user_search(username)
    TwitterHelper.format_many_prey(prey).first
  end

  def self.fetch_tweets(prey_uid, options = {})
    tweets = CLIENT.user_timeline(prey_uid.to_i, options)
    TwitterHelper.format_many_tweets(tweets)
  end
end
