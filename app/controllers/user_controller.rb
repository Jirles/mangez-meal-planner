
class UserController < AppController

  get '/signup' do
    redirect_if_logged_in
    erb :'users/signup'
  end

  post '/signup' do
    user = User.new(params)
    if user.save
      session[:user_id] = user.id
      redirect '/recipes'
    else
      if User.find_by(username: params[:username])
        flash[:message] = "That username is already taken. Please pick another."
      else
        flash[:message] = "Please fill out all fields."
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
    @user = User.find_by_slug(params[:slug])
    access_check(@user.id)

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
