class TwitterUser < ActiveRecord::Base
  has_many :tweets

  MAX_STALE_TIME = 10

  def stale?(num)
    tweets = self.tweets.limit(num).order("twitter_created_at ASC")

    tweet_diffs = []
    tweets.each_with_index do |tweet, i|
      tweet_diffs << (tweets[i + 1].twitter_created_at - tweet.twitter_created_at) unless i == tweets.length - 1
    end

    stale_time = tweet_diffs.inject { |sum, e| sum + e }.to_f / tweet_diffs.size

    stale_time = MAX_STALE_TIME if stale_time > MAX_STALE_TIME

    if (Time.now - tweets.last.updated_at) > stale_time
      return true
    end
    false
  end

  def first_pull?
    self.tweets.count == 0
  end

  def pull_tweets(num)
    @tweets = []
    Twitter.user_timeline(self.username, :count => num, :result_type => "recent").each do |tweet|
      tweet = Tweet.find_or_create_by_content_and_twitter_created_at_and_twitter_user_id(
        :content => tweet.text, 
        :twitter_created_at => tweet.created_at, 
        :twitter_user_id => self.id
      )
      tweet.update_attribute(:updated_at, Time.now)
      @tweets << tweet
    end
    return @tweets
  end
end
