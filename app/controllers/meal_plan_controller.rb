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
    "#{params}"
    #mp = MealPlan.new(name: params[:name], user_id: current_user.id)
    #if params[:breakfast]
      #mp.breafast = params[:breakfast]
    #else
      # redirect '/meal-plans/new' if params[:breakfast_new].values.any?{|v| v.empty?}
      #params[:breakfast_new][:user_id] = current_user.id
      #breakfast = Recipe.create(params[:breakfast_new])
      #mp.breakfast = breakfast.id

    #same for lunch_new and dinner_new
    #mp.save 

    #redirect "/users/profile/#{current_user.slug}"
  end
end
