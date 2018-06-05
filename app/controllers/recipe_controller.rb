class RecipeController < AppController

  get '/recipes' do
    redirect_if_not_logged_in
    @user = current_user

    erb :'recipes/index'
  end

  get '/recipes/new' do
    redirect_if_not_logged_in
    @user = current_user

    erb :'recipes/create_recipe'
  end

  post '/recipes' do
    "#{params}"
  end
end
