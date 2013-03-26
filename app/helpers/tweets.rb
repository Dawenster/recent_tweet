class Tweets
  attr_reader :username, :num_tweets

  def initialize(username)
    @username = username
    @num_tweets = 100
    @user = TwitterUser.find_or_create_by_username(:username => @username)
  end

  def should_pull?
    @user.first_pull? || @user.stale?(@num_tweets)
  end

  def get
    @user.pull_tweets(@num_tweets) if should_pull?
    @user.tweets.limit(@num_tweets).order("twitter_created_at DESC")
  end
end
