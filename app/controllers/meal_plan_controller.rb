class MealPlanController < AppController

  get '/meal-plans/new' do
    redirect_if_not_logged_in
    @user = current_user

    erb :'meal_plans/create_mp'
  end

  post '/meal-plans' do
    params[:user_id] = current_user.id
    MealPlan.create(params)

    redirect "/users/profile/#{current_user.slug}"
  end
end
