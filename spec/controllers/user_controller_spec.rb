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

     it 'cannot be viewed by a user who has already signed in' do
       params = {
          :username => "testking",
          :email => "long_live_the_king@test.com",
          :password => "testingtesting"
        }
        post '/signup', params

        visit '/signup'
        expect(last_response.location).to include('/recipes')
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
      params = {:username => "testking", :password => "testingtesting"}
      post '/login', params

      visit '/recipes'
      expect(last_response.location).to include("/recipes")
    end
  end

  context 'logout action' do
    it 'logs a person out of the app' do
      params = { :username => "testking", :password => "testingtesting"}
      post '/login', params

      get '/logout'
      get '/recipes' #=> set up to redirect to login if no user is currently logged in
      expect(last_response.location).to include('/login')
    end
  end

end