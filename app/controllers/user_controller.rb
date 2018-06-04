class UserController < AppController

  get '/signup' do
    erb :'users/signup'
  end

  post '/signup' do
    user = User.create(params)
    session[:user_id] = user.id
    redirect '/recipes'
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

  get '/logout' do
    session.clear
    redirect '/'
  end

end