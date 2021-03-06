require 'spec_helper'

describe 'Recipe' do
  before do
    @user = User.create(username: "testqueen", email: "all_hail@test.com", password: "supersecret")
    @user2 = User.create(username: "the best ever", email: "awesome@me.com", password: "thebestpassword")

    @mac_n_cheese = Recipe.create(name: "Mac 'n' Cheese", ingredients: "cheese, macaroni, milk, butter", instruction: "mix it together in a pot", user_id: @user.id)

    @cobb_salad = Recipe.create(name: "Cobb Salad", ingredients: "lettuce greens, eggs, chicken, dressing of choice", instruction: "mix it together in a bowl", user_id: @user.id)

    @oatmeal = Recipe.create(name: "Savory Oatmeal", ingredients: "oatmeal, vegetable stock, spinach, egg", instruction: "make oatmeal with vegetable stock, top with wilted spinach and a fried egg", user_id: @user2.id)

  end

  it 'has a name, ingredients, and instruction' do
    expect(@mac_n_cheese.name).to eq("Mac 'n' Cheese")
    expect(@mac_n_cheese.ingredients).to include("milk, butter")
    expect(@mac_n_cheese.instruction).to eq("mix it together in a pot")
  end

  it 'does not initialize without a name, ingredients, or instruction' do
    expect{Recipe.create(name: "yummy", instruction: "put it in your mouth")}.to raise_error{ |error| expect(error).to be_a(ActiveRecord::StatementInvalid) }

    expect{Recipe.create(ingredients: "chocoloate, flour, love", instruction: "put it in your mouth")}.to raise_error{ |error| expect(error).to be_a(ActiveRecord::StatementInvalid) }

    expect{Recipe.create(name: "yummy", ingredients: "chocoloate, flour, love")}.to raise_error{ |error| expect(error).to be_a(ActiveRecord::StatementInvalid) }
  end

  it ' belong to a user' do
    expect(@mac_n_cheese.user).to eq(@user)
    expect(@oatmeal.user).to eq(@user2)
  end
end
