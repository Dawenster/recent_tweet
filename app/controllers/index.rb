get '/:username' do
  
  @tweets = Tweets.new(params[:username])

  if @tweets.should_pull? && !request.xhr?
    erb :loader
  else
    erb :recent, :layout => !request.xhr?
  end

end
