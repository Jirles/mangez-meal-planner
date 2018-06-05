class UserController < AppController

  get '/signup' do
    erb :'users/signup'
  end

  post '/signup' do
    user = User.create(params)
    if user.id #=> will be nil if the object could not be saved to db
      session[:user_id] = user.id
      redirect '/recipes'
    else
      redirect '/signup'
    end
  end

  get '/login' do
    erb :'users/login'
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/recipes'
    else
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

end
