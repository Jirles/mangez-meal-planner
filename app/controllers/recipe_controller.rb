
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
    @recipe = set_recipe

    erb :'recipes/show_recipe'
  end

  get '/recipes/:id/edit' do
    @recipe = set_recipe
    access_check(@recipe.user_id)

    erb :'recipes/edit_recipe'
  end

  post '/recipes' do
    if !valid_recipe_submission?(params)
      flash[:message] = "Please fill in all fields."
      redirect '/recipes/new'
    end

    params[:user_id] = current_user.id
    recipe = Recipe.create(params)
    redirect "/recipes/#{recipe.id}"
  end

  patch '/recipes/:id' do
    @user = set_recipe.user
    access_check(@user.id)

    recipe = set_recipe
    if !valid_recipe_submission?(params)
      flash[:message] = "Please fill in all fields."
      redirect "/recipes/#{recipe.id}/edit"
    end

    recipe.name = params[:name]
    recipe.ingredients = params[:ingredients]
    recipe.instruction = params[:instruction]
    recipe.save

    redirect "/recipes/#{recipe.id}"
  end

  delete '/recipes/:id/delete' do
    @recipe = set_recipe
    access_check(@recipe.user_id)

    @recipe.destroy

    redirect '/recipes'
  end

  helpers do
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end
  end

end
