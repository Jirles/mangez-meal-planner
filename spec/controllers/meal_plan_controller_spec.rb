require 'spec_helper'

describe "Meal Plan Controller" do
  before do
    @user = User.create(username: "test queen", email: "all_hail@test.com", password: "supersecret")
    @mac_n_cheese = Recipe.create(name: "Mac 'n' Cheese", ingredients: "cheese, macaroni, milk, butter", instruction: "mix it together in a pot", user_id: @user.id)
    @cobb_salad = Recipe.create(name: "Cobb Salad", ingredients: "lettuce greens, eggs, chicken, dressing of choice", instruction: "mix it together in a bowl", user_id: @user.id)
    @cereal = Recipe.create(name:"Fruity Pebbles", ingredients: "fruity pebbles, milk", instruction:"pour into a bowl", user_id: @user.id)
    visit '/login'
    fill_in(:username, :with => "test queen")
    fill_in(:password, :with => "supersecret")
    click_button "Log In"
  end

  context "create meal plan page" do
    it "displays a form to the user to create a meal plan" do
      visit "/users/profile/#{@user.slug}"
      click_link "Create New Meal Plan"

      expect(page.status_code).to eq(200)
      expect(page.body).to include("Create a Meal Plan")
      expect(page).to have_selector("form")
    end

    it "contains a form with radio buttons for breakfast, lunch, and dinner" do
      visit '/meal-plans/new'

      expect(page).to have_unchecked_field("#{@mac_n_cheese.id}")
      expect(page).to have_unchecked_field("#{@cobb_salad.id}")
      expect(page).to have_unchecked_field("#{@cereal.id}")
    end
    it 'contains fields for creating a new recipe' do
      visit '/meal-plans/new'

      expect(page).to have_field("Name")
      expect(page).to have_field("Ingredients")
      expect(page).to have_field("Instruction")
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

    it "saves a meal plan with the default name if a name is not supplied" do
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

  context "view meal plan page" do
    before do
      @noice_mp = MealPlan.create({
        :name => "Noice Meal Plan",
        :breakfast => @cereal.id,
        :lunch => @mac_n_cheese.id,
        :dinner => @cobb_salad.id,
        :user_id => @user.id
      })
    end

    it "shows an individual recipe and its details" do
      get "/meal-plans/#{@noice_mp.id}"

      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Noice Meal Plan")
      expect(last_response.body).to have_link("Fruity Pebbles")
    end

    it "does not let a user visit unless they are logged in" do
      get '/logout'

      get "/recipes/#{@noice_mp.id}"
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.body).to include("Welcome back")
    end

    it "does not let a user visit unless they have owner permissions" do
      get '/logout'
      User.create(:username => "testking", :email => "long_live_the_king@test.com", :password => "testingtesting")
      params = {:username => "testking", :password => "testingtesting"}
      post '/login', params

      get "/recipes/#{@noice_mp.id}"
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.body).to include("Welcome, testking")
      expect(last_response.location).to include("/profile/testking")
    end
  end
end
