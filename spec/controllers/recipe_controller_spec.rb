require 'spec_helper'
require 'pry'

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

  context "create recipe page" do
    before do
      User.create(username: "test queen", email: "all_hail@test.com", password: "supersecret")
    end

    it "displays a form to the user to create a recipe" do
      params = {username: "test queen", password: "supersecret"}
      post '/login', params

      get '/recipes/new'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Create a Recipe")
      expect(last_response.body).to include("</form>")
    end

    xit "contains a form with fields for name, ingredients, and instruction" do
      params = {username: "test queen", password: "supersecret"}
      post '/login', params

      get '/recipes/new'
      binding.pry
      fill_in(:name, :with => "Pizza")
      fill_in(:ingredients, :with => "dough, cheese, marinara sauce, pepperoni")
      fill_in(:instruction, :with => "put cheese, marinara sauce, and pepperoni on dough and bake")
    end

  end


end
