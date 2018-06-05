require 'pry'

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

  get '/recipes/:id' do
    redirect_if_not_logged_in
    @recipe = Recipe.find(params[:id])

    erb :'/recipes/show_recipe'
  end

  post '/recipes' do
    Recipe.create(params)
    redirect '/recipes'
  end
end
