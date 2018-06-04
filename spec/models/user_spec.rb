require 'spec_helper'

describe 'User' do
  before do
    @user = User.create(username: "testqueen", email: "all_hail@test.com", password: "supersecret")
    @user2 = User.create(username: "the best ever", email: "awesome@me.com", password: "thebestpassword")
    @mac_n_cheese = Recipe.create(name: "Mac 'n' Cheese", ingredients: "cheese, macaroni, milk, butter", instruction: "mix it together in a pot")
    @user.recipes << @mac_n_cheese

    @cobb_salad = Recipe.create(name: "Cobb Salad", ingredients: "lettuce greens, eggs, chicken, dressing of choice", instruction: "mix it together in a bowl")
    @user.recipes << @cobb_salad

    @oatmeal = Recipe.create(name: "Savory Oatmeal", ingredients: "oatmeal, vegetable stock, spinach, egg", instruction: "make oatmeal with vegetable stock, top with wilted spinach and a fried egg")
    @user.recipes << @oatmeal

    @meal_plan = MealPlan.create(name: "Rockin' Meal Plan", breakfast: @oatmeal.id, lunch: @cobb_salad.id, dinner: @mac_n_cheese.id, user_id: @user.id)
  end

  it 'has a username, email, and secure password' do
    expect(@user.username).to eq("testqueen")
    expect(@user.email).to eq("all_hail@test.com")
    expect(@user.authenticate("supersecret")).to be_truthy
  end

  it 'does not initialize without a username, email, or password' do

    expect(User.create(username: "FAIL", email: "fail@ure.com")).to be_falsey
    expect{User.create(email: "fail@ure.com", password: "failyfail")}.to raise_error{ |error| expect(error).to be_a(ActiveRecord::StatementInvalid) }

    expect{User.create(username: "FAIL", password: "failyfail")}.to raise_error{ |error| expect(error).to be_a(ActiveRecord::StatementInvalid) }
  end

  it 'can have multiple recipes' do
    expect(@user.recipes.size).to eq(2)
    expect(@user.recipes).to include(@cobb_salad)
  end

  it 'can have a meal plan' do
    expect(@user.meal_plans).to include(@meal_plan)
  end

  it 'can slugify its username' do

    expect(@user.slug).to eq("testqueen")
    expect(user2.slug).to eq("the-best-ever")
  end

  it 'can find a user by its slug' do

    expect(User.find_by_slug("the-best-ever")).to eq(@user2)
  end
end
