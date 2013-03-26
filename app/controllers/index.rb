get '/:username' do
  
  @tweets = Tweets.new(params[:username])

  if @tweets.stale? && !request.xhr?
    erb :loader
  else
    erb :recent, :layout => !request.xhr?
  end

end
