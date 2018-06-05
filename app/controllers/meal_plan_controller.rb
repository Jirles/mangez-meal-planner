class MealPlanController < AppController

  get '/meal-plans/new' do
    redirect_if_not_logged_in
    @user = current_user
    
    erb :'meal_plans/create_mp'
  end
end
