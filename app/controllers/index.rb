get '/' do
end

get '/:username' do
  @user = TwitterUser.find_or_create_by_username(:username => params[:username])

  if @user.first_pull? || @user.stale?(5)
    @user.pull_tweets(5)
  end

  @num_tweets = 5
  @tweets = @user.tweets.limit(@num_tweets).order("twitter_created_at DESC")
  erb :recent
end
