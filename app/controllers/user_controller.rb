class UserController < AppController

  get '/signup' do
    redirect_if_logged_in
    erb :'users/signup'
  end

  post '/signup' do
    user = User.create(params)
    if user.id #=> will be nil if the object could not be saved to db
      session[:user_id] = user.id
      redirect '/recipes'
    else
      if params.values.any? {|v| v.empty? }
        flash[:message] = "Please fill out all fields."
      else
        flash[:message] = "That username is already taken. Please pick another."
      end 
      redirect '/signup'
    end
  end

  get '/login' do
    redirect_if_logged_in
    erb :'users/login'
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/recipes'
    else
      flash[:message] = "Username or password incorrect. Please try again."
      redirect '/login'
    end
  end

  get '/users/profile' do
    redirect_if_not_logged_in
    redirect "/users/profile/#{current_user.slug}"
  end

  get '/users/profile/:slug' do
    redirect_if_not_logged_in
    redirect '/recipes' if current_user.slug != params[:slug]

    @user = User.find_by_slug(params[:slug])
    erb :'/users/show'
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  helpers do
    def redirect_if_logged_in
      redirect "/recipes" if logged_in?
    end
  end

end
