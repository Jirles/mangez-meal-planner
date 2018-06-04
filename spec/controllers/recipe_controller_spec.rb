require 'spec_helper'

describe "Recipe Controller" do
  context "recipe index page" do
    before do
      @user = User.create(username: "test queen", email: "all_hail@test.com", password: "supersecret")
      Recipe.create(name: "Mac 'n' Cheese", ingredients: "cheese, macaroni, milk, butter", instruction: "mix it together in a pot", user_id: @user.id)
      Recipe.create(name: "Cobb Salad", ingredients: "lettuce greens, eggs, chicken, dressing of choice", instruction: "mix it together in a bowl", user_id: @user.id)
    end

    it "users can only visit the index page if they are already logged in" do
      get '/logout'

      get '/recipes'
      expect(last_response.location).to include("/login")
    end

    it "displays recipes to the user" do
      params = {username: "test queen", password: "supersecret"}
      post '/login', params

      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Mac 'n' Cheese")
    end
  end

end
