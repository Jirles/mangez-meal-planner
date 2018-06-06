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

    it 'creates a new instance of a meal plan then redirects a user to the meal plan view page' do
      visit "/users/profile/#{@user.slug}"
      click_link "Create New Meal Plan"

      fill_in(:plan_name, :with => "Noice Meal Plan")
      within(:css, '#breakfast'){choose "#{@cereal.id}"}
      within(:css, '#lunch'){choose "#{@cobb_salad.id}"}
      within(:css, '#dinner'){choose "#{@mac_n_cheese.id}"}
      click_button "Create"

      expect(MealPlan.last.name).to eq("Noice Meal Plan")
      expect(page.current_url).to include("/meal-plans/#{MealPlan.last.id}")
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

    it 'can create a new recipe using a nested form' do
      visit '/meal-plans/new'
      fill_in(:plan_name, :with => "Noice Meal Plan")
      within(:css, '#breakfast'){choose "#{@cereal.id}"}
      within(:css, '#lunch'){choose "#{@cobb_salad.id}"}
      fill_in(:dn_new_name, :with => "Pizza")
      fill_in(:dn_new_ingredients, :with => "dough, marinara, mozzarella, pepperoni")
      fill_in(:dn_new_instruction, :with => "top dough with marinara, mozzarella, and pepperoni. bake")
      click_button "Create"

      expect(page.current_url).to include("/meal-plans/#{MealPlan.last.id}")
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
      @noice_mp = MealPlan.create(:name => "Noice Meal Plan", :breakfast => @cereal.id, :lunch => @cobb_salad.id, :dinner => @mac_n_cheese.id, :user_id => @user.id)
      visit "/meal-plans/#{@noice_mp.id}"
    end

    it "shows a meal plan and its recipes" do
      expect(page.status_code).to eq(200)
      expect(page.body).to include("Noice Meal Plan")
      expect(page).to have_content("Fruity Pebbles")
    end

    it 'contains links to recipe show pages' do
      click_link "Fruity Pebbles"
      expect(page.current_url).to include("/recipes/#{@noice_mp.breakfast}")
    end

    it "does not let a user visit unless they are logged in" do
      visit '/logout'

      visit "/recipes/#{@noice_mp.id}"
      expect(page.current_url).to include("/login")
    end

    it "does not let a user visit unless they have owner permissions" do
      visit '/logout'
      User.create(:username => "testking", :email => "long_live_the_king@test.com", :password => "testingtesting")
      visit '/login'
      fill_in(:username, :with => "testking")
      fill_in(:password, :with => "testingtesting")
      click_button "Log In"
      visit "/meal-plans/#{@noice_mp.id}"

      expect(page.body).to include("Welcome, testking")
      expect(page.current_url).to include("/recipes")
    end

    it 'has an Edit button, a Shopping List button, and a Delete button' do
      expect(page).to have_button("Edit")
      expect(page).to have_button("Shopping List")
      expect(page).to have_button("Delete")
    end
  end

  context "edit meal plan page" do
    before do
      @noice_mp = MealPlan.create(:name => "Noice Meal Plan", :breakfast => @cereal.id, :lunch => @cobb_salad.id, :dinner => @mac_n_cheese.id, :user_id => @user.id)
      @pizza = Recipe.create(:name => "Pizza", :ingredients => "dough, mozzarella, marinara, pepperoni", :instruction => "top dough with mozzarella, marinara, and pepperoni. bake", :user_id => @user.id)
      visit "/meal-plans/#{@noice_mp.id}/edit"
    end

    it "has a form with pre-checked radio buttons" do
      expect(page).to have_selector("form")
      expect(page).to have_checked_field("#{@cereal.id}")
      expect(page).to have_checked_field("#{@cobb_salad.id}")
    end

    it 'sends a patch request to the controller' do
      expect(find("#hidden", :visible => false).value).to eq("patch")
    end

    it 'edits a meal plan and redirects the user to the meal plan view page' do
      within(:css, '#dinner'){choose "#{@pizza.id}"}
      click_button "Save"

      expect(page.current_url).to include("/meal-plans/#{@noice_mp.id}")
      expect(page).to have_link("Fruity Pebbles")
      expect(page).to have_link("Cobb Salad")
      expect(page).to have_link("Pizza")
      expect(MealPlan.find(@noice_mp.id).dinner).to eq(@pizza.id)
    end

    it 'can create a new recipe using a nested form' do

      within(:css, '#breakfast'){choose "#{@cereal.id}"}
      within(:css, '#lunch'){choose "create_new"}
      fill_in(:ln_new_name, :with => "Pizza")
      fill_in(:ln_new_ingredients, :with => "dough, marinara, mozzarella, pepperoni")
      fill_in(:ln_new_instruction, :with => "top dough with marinara, mozzarella, and pepperoni. bake")
      within(:css, '#dinner'){choose "#{@cobb_salad.id}"}
      click_button "Create"

      expect(page.current_url).to include("/meal-plans/#{MealPlan.last.id}")
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
end
