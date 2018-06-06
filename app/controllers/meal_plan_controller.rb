require 'pry'

class MealPlanController < AppController

  get '/meal-plans/new' do
    redirect_if_not_logged_in
    @user = current_user

    erb :'meal_plans/create_mp'
  end

  get '/meal-plans/:id' do
    @meal_plan = MealPlan.find(params[:id])
    access_check(@meal_plan)

    erb :'meal_plans/show_mp'
  end

  get '/meal-plans/:id/edit' do
    @meal_plan = MealPlan.find(params[:id])
    access_check(@meal_plan)
    @user = current_user

    erb :'meal_plans/edit_mp'
  end

  post '/meal-plans' do
    mp = MealPlan.new(name: params[:name], user_id: current_user.id)
    #breakfast
    mp.breakfast = set_meal_field(to_url: '/meal-plans/new', meal:"breakfast")
    #lunch
    mp.lunch = set_meal_field(to_url: '/meal-plans/new', meal: "lunch")
    #dinner
    mp.dinner = set_meal_field(to_url: '/meal-plans/new', meal: "dinner")
    mp.save
    redirect "/users/profile/#{current_user.slug}"
  end

  patch '/meal-plans/:id' do
    mp = MealPlan.find(params[:id])
    #breakfast
    mp.breakfast = set_meal_field(to_url: "/meal-plans/#{mp.id}/edit", meal: "breakfast")
    #lunch
    mp.lunch = set_meal_field(to_url: "/meal-plans/#{mp.id}/edit", meal: "lunch")
    #dinner
    mp.dinner = set_meal_field(to_url: "/meal-plans/#{mp.id}/edit", meal: "dinner")
    mp.save
    redirect "/users/profile/#{current_user.slug}"
  end

  helpers do
    def valid_new_recipe?(to_url, key)
      redirect to_url if params[key].values.any?{|v| v.empty?}
    end

    def set_meal_field(to_url, meal)
      nested_hash_key = meal + "_new"
      if params[meal]
        return params[meal]
      else
        valid_new_recipe?(to_url, nested_hash_key)
        params[nested_hash_key][:user_id] = current_user.id
        Recipe.create(params[nested_hash_key]).id
      end
    end

  end
end
