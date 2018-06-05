class AppController < Sinatra::Base
  configure do
    set :views, 'app/views'
    set :public_folder, 'public'
    enable :sessions
    set :session_secret, 'bonappetit!'
  end

  get '/' do
    erb :home
  end

  helpers do

    def logged_in?
      !!session[:user_id]
    end

    def redirect_if_not_logged_in
      redirect '/login' if !logged_in?
    end

    def current_user
      User.find(session[:user_id])
    end

    def owner_permissions_check(obj)
      redirect_if_not_logged_in
      redirect '/recipes' if obj.user_id != current_user.id
    end
  end

end
