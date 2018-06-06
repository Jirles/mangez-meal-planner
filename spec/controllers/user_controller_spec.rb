require 'spec_helper'

describe 'UserController' do
  context 'signup page' do
    before do
      visit '/signup'
    end

    it 'when a user is directed to the signup page they see a form' do
      expect(page.status_code).to eq(200)
      expect(page.body).to include("</form>")
    end

    it 'has a form with fields for username, email, and password' do
      fill_in(:username, :with => "testqueen")
      fill_in(:email, :with => "all_hail@test.com")
      fill_in(:password, :with => "testytest")
    end

    it 'creates a new user and sends them to their recipes index' do
      params = {
         :username => "testqueen",
         :email => "all_hail@test.com",
         :password => "testytest"
       }
       post '/signup', params
       expect(last_response.location).to include("/recipes")
     end

     it 'only accepts unique usernames, i.e. not already in db' do
       User.create(:username => "testking", :email => "long_live_the_king@test.com", :password => "testingtesting")

       visit '/signup'
       fill_in(:username, :with => "testking")
       fill_in(:email, :with => "different_king@test.com")
       fill_in(:password, :with => "somethingelse")
       click_button "Submit"

       expect(page.current_url).to include("/signup")
       expect(page).to have_content("That username is already taken. Please pick another.")
       expect(User.find_by(email: "different_king@test.com")).to be_nil
     end

     it 'does not accept a form that contains empty fields' do
       params = {
         :email => "different_king@test.com",
         :password => "somethingelse"
       }
       post '/signup', params

       expect(last_response.body).to include("Please fill out all fields.")
       expect(User.find_by(email: "different_king@test.com")).to be_nil
     end

     it 'cannot be viewed by a user who has already logged in' do
       fill_in(:username, :with => "testqueen")
       fill_in(:email, :with => "all_hail@test.com")
       fill_in(:password, :with => "testytest")
       click_button "Submit"

       visit '/signup'
       expect(page.current_url).to include('/recipes')
     end
  end

  context 'login page' do
    before do
      User.create(:username => "testking", :email => "long_live_the_king@test.com", :password => "testingtesting")
    end

    it 'when a user is directed to the login page they see a form' do
      visit '/login'
      expect(page.status_code).to eq(200)
      expect(page.body).to include("</form>")
    end

    it 'has a form with fields for username and password' do
      visit '/login'
      fill_in(:username, :with => "testking")
      fill_in(:password, :with => "testingtesting")
    end

    it 'redirects a user to the recipes index after log in' do
      visit '/login'
      fill_in(:username, :with => "testking")
      fill_in(:password, :with => "testingtesting")
      click_button "Log In"

      expect(page.current_url).to include("/recipes")
    end

    it 'redirects a user to the login page if the username or password was entered incorrectly' do
      visit '/login'
      fill_in(:username, :with => "test king")
      fill_in(:password, :with => "testingtesting")
      click_button "Log In"

      expect(page.current_url).to include("/login")
      expect(page).to have_content("Username or password incorrect. Please try again.")
    end
  end

  describe 'user profiles paths' do
    before do
       visit '/signup'
       fill_in(:username, :with => "test queen")
       fill_in(:email, :with => "all_hail@test.com")
       fill_in(:password, :with => "testytest")
       click_button "Submit"
      @user = User.last
    end

    it 'directs a user to their individual profile page when they link to users/profile' do
      visit 'users/profile'

      expect(page.current_url).to include("/profile/test-queen")
    end

    it "/profile/:slug displays a user's recipes and meal plans" do
      mc = Recipe.create(name: "Mac 'n' Cheese", ingredients: "cheese, macaroni, milk, butter", instruction: "mix it together in a pot", user_id: @user.id)
      cobb = @cobb_salad = Recipe.create(name: "Cobb Salad", ingredients: "lettuce greens, eggs, chicken, dressing of choice", instruction: "mix it together in a bowl", user_id: @user.id)
      MealPlan.create(name: "Delicious Meals", lunch: mc.id, dinner: cobb.id, user_id: @user.id)

      visit 'users/profile/test-queen'
      expect(page.body).to include("Welcome, test queen")
      expect(page.body).to include("Mac 'n' Cheese")
      expect(page.body).to include("Delicious Meals")
    end

    it 'only allows the current_user to access their profile' do
      get 'logout'
      params = {:username => "testking", :email => "long_live_the_king@test.com", :password => "testingtesting"}
      post '/signup', params

      get '/users/profile'
      expect(last_response.location).to include("/profile/testking")
      get '/users/profile/test-queen'
      expect(last_response.location).to include("/recipes")
    end

    it 'cannot be accessed when a user is logged out' do
      visit 'logout'

      visit '/users/profile/test-queen'
      expect(page.current_url).to include('/login')
      expect(page).to have_content("You must be logged in to view this content.")
    end
  end

  context 'logout action' do
    it 'logs a person out of the app' do
      visit '/logout'
      visit '/recipes' #=> set up to redirect to login if no user is currently logged in

      expect(page.current_url).to include('/login')
      expect(page).to have_content("You must be logged in to view this content.")
    end
  end

end
