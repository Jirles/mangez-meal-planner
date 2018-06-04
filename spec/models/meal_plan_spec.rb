require 'spec_helper'

describe 'MealPlan' do
  before do
    @user = User.create(username: "testqueen", email: "all_hail@test.com", password: "supersecret")
    @user2 = User.create(username: "the best ever", email: "awesome@me.com", password: "thebestpassword")

    @mac_n_cheese = Recipe.create(name: "Mac 'n' Cheese", ingredients: "cheese, macaroni, milk, butter", instruction: "mix it together in a pot", user_id: @user.id)
    @cobb_salad = Recipe.create(name: "Cobb Salad", ingredients: "lettuce greens, eggs, chicken, dressing of choice", instruction: "mix it together in a bowl", user_id: @user.id)
    @cereal = Recipe.create(name:"Fruity Pebbles", ingredients: "fruity pebbles, milk", instruction:"pour into a bowl", user_id: @user.id)

    @oatmeal = Recipe.create(name: "Savory Oatmeal", ingredients: "oatmeal, vegetable stock, spinach, egg", instruction: "make oatmeal with vegetable stock, top with wilted spinach and a fried egg", user_id: @user2.id)
    @hamburger = Recipe.create(name: "Hamburger", ingredients: "beef, onion, buns, ketchup, tomato", instruction: "put them together", user_id: @user2.id)

    @meal_plan = MealPlan.create(name: "Rockin' Meal Plan", breakfast: @cereal.id, lunch: @cobb_salad.id, dinner: @mac_n_cheese.id, user_id: @user.id)
    @meal_plan2 = MealPlan.create(breakfast: @oatmeal.id, dinner: @hamburger.id, user_id: @user2.id)
  end

  it 'can have recipe ids for breakfast, lunch, and/or dinner fields' do
    expect(Recipe.find(@meal_plan.breakfast)).to be_instance_of(Recipe)
    expect(Recipe.find(@meal_plan2.dinner)).to eq(@hamburger)
  end

  it 'belongs to a User' do
    expect(@meal_plan2.user).to eq(@user2)
  end

  it 'does not initialize without a user_id' do
    expect{MealPlan.create(breakfast: @oatmeal.id, lunch: @cobb_salad.id, dinner: @mac_n_cheese.id)}.to raise_error{ |error| expect(error).to be_a(ActiveRecord::StatementInvalid) }
  end

  it 'has a default name if not specified on creation' do
    expect(@meal_plan2.name).to eq("Your Meal Plan")
  end

end
