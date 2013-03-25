class TwitterUser < ActiveRecord::Base
  has_many :tweets

  def stale?(num)
    @tweets = self.tweets.limit(num).order("twitter_created_at DESC")

    @tweet_diffs = []

    @tweets.each_with_index do |tweet, i|
      @tweet_diffs << (@tweets[i + 1].twitter_created_at - tweet.twitter_created_at) unless i == @tweets.length - 1
    end

    @stale_time = @tweet_diffs.inject { |sum, e| sum + e }.to_f / @tweet_diffs.size

    if (Time.now - self.tweets.last.twitter_created_at) > @stale_time
      return true
    end
    false
  end

  def first_pull?
    self.tweets.count == 0
  end

  def pull_tweets(num)
    Twitter.user_timeline(self.username, :count => num, :result_type => "recent").each do |tweet|
      @current_tweet = Tweet.find_or_create_by_content_and_twitter_created_at_and_twitter_user_id(:content => tweet.text, :twitter_created_at => tweet.created_at, :twitter_user_id => self.id)
      @current_tweet.update_attributes(:updated_at => Time.now)
    end
  end
end
