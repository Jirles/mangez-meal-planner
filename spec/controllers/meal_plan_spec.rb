require 'spec_helper'

describe "Meal Plan Controller" do
    context "create meal plan page" do
    before do
      @user = User.create(username: "test queen", email: "all_hail@test.com", password: "supersecret")
      @mac_n_cheese = Recipe.create(name: "Mac 'n' Cheese", ingredients: "cheese, macaroni, milk, butter", instruction: "mix it together in a pot", user_id: @user.id)
      @cobb_salad = Recipe.create(name: "Cobb Salad", ingredients: "lettuce greens, eggs, chicken, dressing of choice", instruction: "mix it together in a bowl", user_id: @user.id)
      @cereal = Recipe.create(name:"Fruity Pebbles", ingredients: "fruity pebbles, milk", instruction:"pour into a bowl", user_id: @user.id)
      params = {username: "test queen", password: "supersecret"}
      post '/login', params
    end

    it "displays a form to the user to create a meal plan" do
      get '/meal-plans/new'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Create a Meal Plan")
      expect(last_response.body).to include("</form>")
    end

    it "contains a form with radio buttons for breakfast, lunch, and dinner" do
      get '/meal-plans/new'

      expect(last_response.body).to include('type="radio"')
      expect(last_response.body).to include("Fruity Pebbles")
      expect(last_response.body).to include("Mac 'n' Cheese")
      expect(last_response.body).to include("Cobb Salad")
    end
    it 'creates a new instance of a meal plan then redirects a user to their profile' do
      params = {
        :name => "Noice Meal Plan",
        :breakfast => @cereal.id,
        :lunch => @mac_n_cheese.id,
        :dinner => @cobb_salad.id,
        :user_id => @user.id
      }
      post '/meal-plans', params

      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.body).to include("Your Meal Plans")
      expect(last_response.body).to include("Noice Meal Plan")
      expect(MealPlan.last.name).to eq("Noice Meal Plan")
    end

    it "does not a user access the page unless they are logged in" do
      get '/logout'

      get '/meal-plans/new'
      expect(last_response.location).to include("/login")
    end

    it "saves a meal plan with the defaul setting if a name is not supplied" do
      params = {
        :breakfast => @cereal.id,
        :lunch => @mac_n_cheese.id,
        :dinner => @cobb_salad.id,
        :user_id => @user.id
      }
      post '/meal-plans', params

      expect(last_response.status).to eq(302)
      follow_redirect!

      expect(last_response.body).to include("Your Meal Plan")
      expect(MealPlan.last.name).to eq("Your Meal Plan")
    end

  end
end
