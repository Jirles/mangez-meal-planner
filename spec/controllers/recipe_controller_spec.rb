require 'spec_helper'

describe "Recipe Controller" do
  context "recipes index page" do
    before do
      @user = User.create(:username => "testking", :email => "long_live_the_king@test.com", :password => "testingtesting")
      Recipe.create(name: "Mac 'n' Cheese", ingredients: "cheese, macaroni, milk, butter", instruction: "mix it together in a pot", user_id: @user.id)
      Recipe.create(name: "Cobb Salad", ingredients: "lettuce greens, eggs, chicken, dressing of choice", instruction: "mix it together in a bowl", user_id: @user.id)
      params = {:username => "testking", :email => "long_live_the_king@test.com", :password => "testingtesting"}
      post '/signup', params
    end

    it "displays all recipes to the user" do
      visit '/recipes'
      expect(page.status_code).to eq(200)
      expect(page.body).to include("Welcome, ")
      expect(page.body).to include("Mac 'n' Cheese")
    end

  end


end
