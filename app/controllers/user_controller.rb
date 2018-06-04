class UserController < AppController

  get '/signup' do
    erb :'users/signup'
  end

  post '/signup' do
    user = User.create(params)
    session[:user_id] = user.id
    redirect '/recipes'
  end

end
