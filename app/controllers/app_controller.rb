require 'rack-flash'

class AppController < Sinatra::Base
  configure do
    set :views, 'app/views'
    set :public_folder, 'public'
    enable :sessions
    set :session_secret, 'bonappetit!'
    use Rack::Flash, :sweep => true
  end

  get '/' do
    erb :home
  end

  helpers do

    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def redirect_if_not_logged_in
      redirect '/login' if !logged_in?
    end

    def owner_permissions_check(obj)
      redirect '/recipes' if obj.user_id != current_user.id
    end

    def access_check(obj)
      redirect_if_not_logged_in
      owner_permissions_check(obj)
    end
  end

end
