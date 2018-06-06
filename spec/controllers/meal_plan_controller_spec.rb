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
      visit "/users/profile/#{@user.slug}"
      click_link "Create New Meal Plan"

      fill_in(:plan_name, :with => "Noice Meal Plan")
      within(:css, '#breakfast'){choose "#{@cereal.id}"}
      within(:css, '#lunch'){choose "#{@cobb_salad.id}"}
      within(:css, '#dinner'){choose "#{@mac_n_cheese.id}"}
      click_button "Create"

      expect(page.current_url).to include("/users/profile/#{@user.slug}")
      expect(page.body).to include("Noice Meal Plan")
      expect(page).to have_link("Fruity Pebbles")
    end

    it 'redirects the user to /meal-plans/new if a field is left empty' do
      visit '/meal-plans/new'

      fill_in(:plan_name, :with => "Noice Meal Plan")
      within(:css, '#breakfast'){choose "#{@cereal.id}"}
      within(:css, '#dinner'){choose "#{@mac_n_cheese.id}"}
      click_button "Create"

      expect(page.current_url).to include("/meal-plans/new")
      expect(MealPlan.all.count).to eq(0)
    end

    it "does not a user access the page unless they are logged in" do
      visit '/logout'

      visit '/meal-plans/new'
      expect(page.current_url).to include("/login")
    end

    it "saves a meal plan with the default name if a name is not supplied" do
      visit '/meal-plans/new'
      within(:css, '#breakfast'){choose "#{@cereal.id}"}
      within(:css, '#lunch'){choose "#{@cobb_salad.id}"}
      within(:css, '#dinner'){choose "#{@mac_n_cheese.id}"}
      click_button "Create"

      expect(page.current_url).to include("/users/profile/#{@user.slug}")
      expect(page.body).to include("Your Meal Plan")
    end

    it 'can create a new recipe using a nested form' do
      visit '/meal-plans/new'
      fill_in(:plan_name, :with => "Noice Meal Plan")
      within(:css, '#breakfast'){choose "#{@cereal.id}"}
      within(:css, '#lunch'){choose "#{@cobb_salad.id}"}
      fill_in(:dn_new_name, :with => "Pizza")
      fill_in(:dn_new_ingredients, :with => "dough, marinara, mozzarella, pepperoni")
      fill_in(:dn_new_instruction, :with => "top dough with marinara, mozzarella, and pepperoni. bake")
      click_button "Create"

      expect(page.current_url).to include("/users/profile/#{@user.slug}")
      expect(page).to have_link("Pizza")
      expect(Recipe.last.name).to eq("Pizza")
    end

    it 'will not make a new recipe if a field is missing' do
      visit '/meal-plans/new'
      fill_in(:plan_name, :with => "Noice Meal Plan")
      within(:css, '#breakfast'){choose "#{@cereal.id}"}
      within(:css, '#lunch'){choose "#{@cobb_salad.id}"}
      fill_in(:dn_new_name, :with => "Pizza")
      fill_in(:dn_new_ingredients, :with => "dough, marinara, mozzarella, pepperoni")
      click_button "Create"

      expect(page.current_url).to include("/meal-plans/new")
      expect(MealPlan.all.count).to eq(0)
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

    xit "shows an individual recipe and its details" do
      get "/meal-plans/#{@noice_mp.id}"

      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Noice Meal Plan")
      expect(last_response.body).to have_link("Fruity Pebbles")
    end

    xit "does not let a user visit unless they are logged in" do
      get '/logout'

      get "/recipes/#{@noice_mp.id}"
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.body).to include("Welcome back")
    end

    xit "does not let a user visit unless they have owner permissions" do
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
