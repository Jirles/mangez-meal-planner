require 'spec_helper'

describe 'Recipe' do
  before do
    @user = User.create(username: "testqueen", email: "all_hail@test.com", password: "supersecret")
    @user2 = User.create(username: "the best ever", email: "awesome@me.com", password: "thebestpassword")
    @mac_n_cheese = Recipe.create(name: "Mac 'n' Cheese", ingredients: "cheese, macaroni, milk, butter", instruction: "mix it together in a pot")
    @user.recipes << @mac_n_cheese

    @cobb_salad = Recipe.create(name: "Cobb Salad", ingredients: "lettuce greens, eggs, chicken, dressing of choice", instruction: "mix it together in a bowl")
    @user.recipes << @cobb_salad

    @oatmeal = Recipe.create(name: "Savory Oatmeal", ingredients: "oatmeal, vegetable stock, spinach, egg", instruction: "make oatmeal with vegetable stock, top with wilted spinach and a fried egg")
    @user.recipes << @oatmeal

    @meal_plan = MealPlan.create(breakfast: @oatmeal, lunch: @cobb_salad, dinner: @mac_n_cheese, user_id: @user.id)
  end

  it 'has a name, ingredients, and instructions' do
    expect(@mac_n_cheese.name).to eq("Mac 'n' Cheese")
    expect(@mac_n_cheese.ingredients).to include("milk, butter")
    expect(@mac_n_cheese.instruction).to eq("mix it together in a pot")
  end

end
