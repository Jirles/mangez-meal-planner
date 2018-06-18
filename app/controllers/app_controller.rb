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

  not_found do
    erb :'404'
  end

  helpers do

    def logged_in?
      !!session[:user_id]
    end

    def current_user
      @current_user ||= User.find(session[:user_id])
    end

    def redirect_if_not_logged_in
      if !logged_in?
        flash[:message] = "You must be logged in to view this content."
        redirect '/login'
      end
    end

    def owner_permissions_check(user_id)
      if user_id != current_user.id
        flash[:message] = "You do not have permissions to view this content."
        redirect '/recipes'
      end
    end

    def access_check(user_id)
      redirect_if_not_logged_in
      owner_permissions_check(user_id)
    end

    def valid_recipe_submission?(params)
      ["name", "ingredients", "instruction"].all?{ |attribute| params[attribute] && !params[attribute].empty? }
    end

  end

end
