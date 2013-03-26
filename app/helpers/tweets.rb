class Tweets
  attr_reader :num_tweets, :username

  def initialize username
    @num_tweets = 100
    @username = username
    @user = TwitterUser.find_or_create_by_username(:username => @username)
  end

  def stale?
    @user.first_pull? || @user.stale?(@num_tweets)
  end

  def get
    @user.pull_tweets(@num_tweets) if stale?
    @user.tweets.limit(@num_tweets).order("twitter_created_at DESC")
  end
end
