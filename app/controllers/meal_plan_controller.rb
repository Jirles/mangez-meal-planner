class MealPlanController < AppController

  get '/meal-plans/new' do
    redirect_if_not_logged_in
    @user = current_user

    erb :'meal_plans/create_mp'
  end

  get '/meal-plans/:id' do
    @meal_plan = MealPlan.find(params[:id])
    access_check(@meal_plan)

    erb :'/meal_plans/show_mp'
  end

  post '/meal-plans' do
    params[:user_id] = current_user.id
    MealPlan.create(params)

    redirect "/users/profile/#{current_user.slug}"
  end
end
