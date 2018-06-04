class RecipeController < AppController

  get '/recipes' do
    #redirect_if_not_logged_in
    @user = current_user
    
    erb :'recipes/index'
  end
end
