require 'spec_helper'
require 'pry'

describe "Recipe Controller" do
  context "recipe index page" do
    before do
      @user = User.create(username: "test queen", email: "all_hail@test.com", password: "supersecret")
      Recipe.create(name: "Mac 'n' Cheese", ingredients: "cheese, macaroni, milk, butter", instruction: "mix it together in a pot", user_id: @user.id)
      Recipe.create(name: "Cobb Salad", ingredients: "lettuce greens, eggs, chicken, dressing of choice", instruction: "mix it together in a bowl", user_id: @user.id)
      visit '/login'
      fill_in(:username, :with => "test queen")
      fill_in(:password, :with => "supersecret")
      click_button "Log In"
    end

    it "users can only visit the index page if they are already logged in" do
      visit '/logout'

      visit '/recipes'
      expect(page.current_url).to include("/login")
      expect(page).to have_content("You must be logged in to view this content.")
    end

    it "displays recipes to the user as links" do
      expect(page.status_code).to eq(200)
      expect(page.current_url).to include("/recipes")
      expect(page).to have_link("Mac 'n' Cheese")
    end
  end

  context "create recipe page" do
    before do
      @user = User.create(username: "test queen", email: "all_hail@test.com", password: "supersecret")
      visit '/login'
      fill_in(:username, :with => "test queen")
      fill_in(:password, :with => "supersecret")
      click_button "Log In"

      visit '/recipes/new'
    end

    it "displays a form to the user to create a recipe" do
      expect(page.status_code).to eq(200)
      expect(page.body).to include("Create a Recipe")
      expect(page.body).to include("</form>")
    end

    it "contains a form with fields for name, ingredients, and instruction" do
      fill_in(:name, :with => "Pizza")
      fill_in(:ingredients, :with => "dough, cheese, marinara sauce, pepperoni")
      fill_in(:instruction, :with => "put cheese, marinara sauce, and pepperoni on dough and bake")
    end

    it 'creates a new instance of a recipe then redirects a user to the recipe index' do
      fill_in(:name, :with => "PB&J")
      fill_in(:ingredients, :with => "peanut butter, jelly, bread")
      fill_in(:instruction, :with => "spread peanut butter and jelly on bread")
      click_button "Create"

      expect(page.current_url).to include("/recipes")
      expect(page.body).to include("PB&J")
      expect(Recipe.last.name).to eq("PB&J")
    end

    it 'redirects the user to the create recipe page if the data submitted was invalid' do
      params = {
        :username => "test queen",
        :password => "supersecret"
      }
      post '/login', params

      params = {
        :name => "PB&J",
        :ingredients => "peanut butter, jelly, bread"
      }
      post '/recipes', params

      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.body).to include("Please fill in all fields.")
    end
  end

  context "view recipe page" do
    before do
      @user = User.create(username: "test queen", email: "all_hail@test.com", password: "supersecret")
      @recipe = Recipe.create(:name => "PB&J", :ingredients => "peanut butter, jelly, bread", :instruction => "spread peanut butter and jelly on bread", :user_id => @user.id)
      visit '/login'
      fill_in(:username, :with => "test queen")
      fill_in(:password, :with => "supersecret")
      click_button "Log In"

      visit "/recipes/#{@recipe.id}"
    end

    it "shows an individual recipe and its details" do
      expect(page.status_code).to eq(200)
      expect(page.body).to include("PB&J")
      expect(page.body).to include("bread")
      expect(page.body).to include("spread peanut butter")
    end

    it "does not let a user visit unless they are logged in" do
      visit '/logout'

      visit "/recipes/#{@recipe.id}"

      expect(page.current_url).to include("/login")
      expect(page).to have_content("You must be logged in to view this content.")
    end

    it 'shows the edit and delete options if a user has owner permissions' do
      expect(page).to have_button('Edit')
      expect(page).to have_button('Delete')
    end

    it 'does not show edit and delete buttons if a user does not have owner permissions' do
      visit '/logout'

      User.create(:username => "testking", :email => "long_live_the_king@test.com", :password => "testingtesting")
      visit '/login'
      fill_in(:username, :with => "testking")
      fill_in(:password, :with => "testingtesting")
      click_button "Log In"

      visit "/recipes/#{@recipe.id}"

      expect(page).not_to have_button("Edit")
      expect(page).not_to have_button("Delete")
    end

    it "has an Add to my Recipe button that appears if a user does not have owner permissions and will add the recipe to their collection" do
      visit '/logout'

      User.create(:username => "testking", :email => "long_live_the_king@test.com", :password => "testingtesting")
      visit '/login'
      fill_in(:username, :with => "testking")
      fill_in(:password, :with => "testingtesting")
      click_button "Log In"

      visit "/recipes/#{@recipe.id}"

      click_button "Add to my Recipes"

      visit "/users/profile/testking"
      expect(page).to have_link("PB&J")
    end

  end

  context "edit recipe page" do
    before do
      @user = User.create(:username => "testking", :email => "long_live_the_king@test.com", :password => "testingtesting")
      @recipe = Recipe.create(:name => "PB&J", :ingredients => "peanut butter, jelly, bread", :instruction => "spread peanut butter and jelly on bread", :user_id => @user.id)
      visit '/login'
      fill_in(:username, :with => "testking")
      fill_in(:password, :with => "testingtesting")
      click_button "Log In"
      visit "/recipes/#{@recipe.id}/edit"
    end

    it 'contains a pre-filled form with recipe information' do
      expect(page.body).to include("</form>")
      expect(page.body).to include('value="PB&J"')
      expect(page.body).to include('value="peanut butter, jelly, bread"')
    end

    it 'allows a user to edit a recipe and save changes and takes them to the view recipe page' do
      fill_in(:instruction, :with => "spread peanut butter and jelly on bread. cut in half. enjoy.")
      click_button "Save"

      expect(page.current_url).to include("/recipes/#{@recipe.id}")
      expect(page.body).to include("spread peanut butter and jelly on bread. cut in half. enjoy.")
    end

    it 'does not allow a user to view the page if they are not logged in' do
      visit '/logout'

      visit "/recipes/#{@recipe.id}/edit"
      expect(page.current_url).to include("/login")
      expect(page).to have_content("You must be logged in to view this content.")
    end

    it "does not allow a user to view the page if they do not have owner permissions" do
      visit '/logout'

      User.create(:username => "test queen", :email => "all_hail@test.com", :password => "supersecret")
      visit '/login'
      fill_in(:username, :with => "test queen")
      fill_in(:password, :with => "supersecret")
      click_button 'Log In'

      visit "/recipes/#{@recipe.id}/edit"
      expect(page.current_url).to include('/recipes')
      expect(page).to have_content("You do not have permissions to view this content.")
    end

    it 'redirects the user to the edit recipe page if the data submitted was invalid' do
      params = {
        :username => "testking",
        :password => "testingtesting"
      }
      post '/login', params

      params = {
        :name => "PB&J",
        :ingredients => "peanut butter, jelly, bread"
      }
      patch "/recipes/#{@recipe.id}", params

      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.body).to include("Please fill in all fields.")
    end

  end

  context "delete recipe action" do
    before do
      @user = User.create(:username => "testking", :email => "long_live_the_king@test.com", :password => "testingtesting")
      @recipe = Recipe.create(:name => "PB&J", :ingredients => "peanut butter, jelly, bread", :instruction => "spread peanut butter and jelly on bread", :user_id => @user.id)
      visit '/login'
      fill_in(:username, :with => "testking")
      fill_in(:password, :with => "testingtesting")
      click_button "Log In"
    end

    it "deletes a recipe and returns the user to the recipe index" do
      visit "/recipes/#{@recipe.id}"
      click_button "Delete"

      expect(page.current_url).to include("/recipes")
      expect(page).not_to have_link("PB&J")
      expect{Recipe.find(@recipe.id)}.to raise_error{ |error| expect(error).to be_a(ActiveRecord::RecordNotFound) }
    end

    it 'does not allow a user to delete a recipe if they are not logged in, redirects them to login page' do
      visit '/logout'

      delete "/recipes/#{@recipe.id}/delete"

      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.body).to include("You must be logged in to view this content.")
      expect(Recipe.find(@recipe.id)).to eq(@recipe)
    end

    it 'does not allow a user to delete a recipe to which they do not have owner permissions' do
      visit '/logout'

      @user = User.create(:username => "test queen", :email => "all_hail@test.com", :password => "supersecret")
      visit '/login'
      params = {
        :username => "test queen",
        :password => "supersecret"
      }
      post '/login', params

      delete "/recipes/#{@recipe.id}/delete"

      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.body).to include("You do not have permissions to view this content.")
      expect(Recipe.find(@recipe.id)).to eq(@recipe)
    end

  end

end
