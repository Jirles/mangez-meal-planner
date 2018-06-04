require 'spec_helper'

describe 'MealPlan' do
  before do
    @user = User.create(username: "testqueen", email: "all_hail@test.com", password: "supersecret")
    @user2 = User.create(username: "the best ever", email: "awesome@me.com", password: "thebestpassword")

    @mac_n_cheese = Recipe.create(name: "Mac 'n' Cheese", ingredients: "cheese, macaroni, milk, butter", instruction: "mix it together in a pot")
    @user.recipes << @mac_n_cheese
    @user2.recipes << @mac_n_cheese

    @cobb_salad = Recipe.create(name: "Cobb Salad", ingredients: "lettuce greens, eggs, chicken, dressing of choice", instruction: "mix it together in a bowl")
    @user.recipes << @cobb_salad

    @oatmeal = Recipe.create(name: "Savory Oatmeal", ingredients: "oatmeal, vegetable stock, spinach, egg", instruction: "make oatmeal with vegetable stock, top with wilted spinach and a fried egg")
    @user.recipes << @oatmeal
    @user2.recipes << @oatmeal

    @meal_plan = MealPlan.create(name: "Rockin' Meal Plan", breakfast: @oatmeal.id, lunch: @cobb_salad.id, dinner: @mac_n_cheese.id, user_id: @user.id)
    @meal_plan2 = MealPlan.create(breakfast: @oatmeal, dinner: @mac_n_cheese, user_id: @user2.id)
  end

  it 'can have instances of Recipe for breakfast, lunch, and/or dinner' do
    expect(@meal_plan.breakfast).to be_instance_of(Recipe)
    expect(@meal_plan2.dinner).to eq(@mac_n_cheese)
  end

  it 'belongs to a User' do
    expect(@meal_plan2.user).to eq(@user2)
  end

  it 'does not initialize without a user_id' do
    failure = MealPlan.create(breakfast: @oatmeal, lunch: @cobb_salad, dinner: @mac_n_cheese)

    expect{Recipe.create(breakfast: @oatmeal, lunch: @cobb_salad, dinner: @mac_n_cheese)}.to raise_error{ |error| expect(error).to be_a(ActiveRecord::StatementInvalid) }
  end

  it 'has a default name if not specified on creation' do
    expect(@meal_plan2.name).to eq("Your Meal Plan")
  end

end
