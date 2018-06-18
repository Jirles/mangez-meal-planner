
class MealPlanController < AppController

  get '/meal-plans/new' do
    redirect_if_not_logged_in
    @user = current_user

    erb :'meal_plans/create_mp'
  end

  get '/meal-plans/:id' do
    @meal_plan = set_mealplan
    access_check(@meal_plan.user_id)

    @breakfast = find_recipe(@meal_plan.breakfast)
    @lunch = find_recipe(@meal_plan.lunch)
    @dinner = find_recipe(@meal_plan.dinner)

    erb :'meal_plans/show_mp'
  end

  get '/meal-plans/:id/edit' do
    @meal_plan = set_mealplan
    access_check(@meal_plan.user_id)
    @user = current_user

    erb :'meal_plans/edit_mp'
  end

  get '/meal-plans/:id/shopping-list' do
    @meal_plan = set_mealplan
    access_check(@meal_plan.user_id)

    @breakfast = find_recipe(@meal_plan.breakfast)
    @lunch = find_recipe(@meal_plan.lunch)
    @dinner = find_recipe(@meal_plan.dinner)

    erb :'/meal_plans/shopping_list'
  end

  post '/meal-plans' do
    mp = MealPlan.new(name: params[:name], user_id: current_user.id)
    #breakfast
    mp.breakfast = set_meal_field(to_url ='/meal-plans/new', meal = "breakfast")
    #lunch
    mp.lunch = set_meal_field(to_url ='/meal-plans/new', meal = "lunch")
    #dinner
    mp.dinner = set_meal_field(to_url = '/meal-plans/new', meal = "dinner")
    mp.save

    redirect "/meal-plans/#{mp.id}"
  end

  patch '/meal-plans/:id' do
    @user = set_mealplan.user
    access_check(@user.id)
    mp = set_mealplan
    #breakfast
    mp.breakfast = set_meal_field(to_url = "/meal-plans/#{mp.id}/edit", meal = "breakfast")
    #lunch
    mp.lunch = set_meal_field(to_url = "/meal-plans/#{mp.id}/edit", meal = "lunch")
    #dinner
    mp.dinner = set_meal_field(to_url = "/meal-plans/#{mp.id}/edit", meal = "dinner")
    mp.save

    redirect "/meal-plans/#{mp.id}"
  end

  delete '/meal-plans/:id/delete' do
    @meal_plan = set_mealplan
    access_check(@meal_plan.user_id)

    @meal_plan.destroy

    redirect "/users/profile/#{@meal_plan.user.slug}"
  end

  helpers do

    def set_mealplan
      MealPlan.find(params[:id])
    end

    def set_meal_field(to_url, meal)
      nested_hash_key = meal + "_new"
      if params[meal] && !params[meal].empty?
        return params[meal]
      else
        if !valid_recipe_submission?(params[nested_hash_key])
          flash[:message] = "Please fill in all fields."
          redirect to_url
        else
          params[nested_hash_key][:user_id] = current_user.id
          Recipe.create(params[nested_hash_key]).id
        end
      end
    end

    def find_recipe(id)
      begin
        Recipe.find(id)
      rescue
        "Recipe not found"
      end
    end

  end

end
