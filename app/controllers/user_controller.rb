class UserController < AppController

  get '/signup' do
    erb :'users/signup'
  end

end
