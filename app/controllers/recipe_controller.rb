require 'pry'

class RecipeController < AppController

  get '/recipes' do
    redirect_if_not_logged_in
    @user = current_user

    erb :'recipes/index'
  end

  get '/recipes/new' do
    redirect_if_not_logged_in

    erb :'recipes/create_recipe'
  end

  get '/recipes/:id' do
    redirect_if_not_logged_in
    @user = current_user
    @recipe = Recipe.find(params[:id])

    erb :'recipes/show_recipe'
  end

  get '/recipes/:id/edit' do
    @recipe = Recipe.find(params[:id])
    access_check(@recipe)

    erb :'recipes/edit_recipe'
  end

  post '/recipes' do
    params[:user_id] = current_user.id
    Recipe.create(params)
    redirect '/recipes'
  end

  patch '/recipes/:id' do
    recipe = Recipe.find(params[:id])
    recipe.name = params[:name]
    recipe.ingredients = params[:ingredients]
    recipe.instruction = params[:instruction]
    recipe.save

    redirect "/recipes/#{recipe.id}"
  end

  delete '/recipes/:id/delete' do
    @recipe = Recipe.find(params[:id])
    access_check(@recipe)

    @recipe.destroy

    redirect '/recipes'
  end

  helpers do
    def valid_recipe_submission?
      ["name", "ingredients", "instruction"].each do |param|

      end

    end
  end

end
