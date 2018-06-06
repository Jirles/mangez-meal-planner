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

    erb :'/meal_plans/show_mp'
  end

  post '/meal-plans' do
    mp = MealPlan.new(name: params[:name], user_id: current_user.id)
    #breakfast
    mp.breakfast = set_meal_field("breakfast")
    #lunch
    mp.lunch = set_meal_field("lunch")
    #dinner
    mp.dinner = set_meal_field("dinner")
    mp.save
    redirect "/users/profile/#{current_user.slug}"
  end

  helpers do
    def valid_new_recipe?(key)
      redirect '/meal-plans/new' if params[key].values.any?{|v| v.empty?}
    end

    def set_meal_field(meal)
      nested_hash_key = meal + "_new"
      if params[meal]
        return params[meal]
      else
        valid_new_recipe?(nested_hash_key)
        params[nested_hash_key][:user_id] = current_user.id
        Recipe.create(params[nested_hash_key]).id
      end
    end

  end
end
