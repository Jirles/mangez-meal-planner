require 'spec_helper'

describe 'UserController' do
  context 'signup page' do
    it 'when a user is directed to the signup page they see a form' do
      visit '/signup'

      expect(page.status_code).to eq(200)
      expect(page.body).to include("</form>")
    end

    it 'has a form with fields for username, email, and password' do
      visit '/signup'

      fill_in(:username, :with => "testqueen")
      fill_in(:email, :with => "all_hail@test.com")
      fill_in(:password, :with => "testytest")
    end

    it 'does not send a form with a blank field' do
      fill_in(:username, :with => "testqueen")
      fill_in(:email, :with => "all_hail@test.com")
      click_button 'submit'

      expect(last_response.location).to include("/signup")
    end

    it 'sends a new user to their profile' do
      params = {
         :username => "skittles123",
         :email => "skittles@aol.com",
         :password => "rainbows"
       }
       post '/signup', params
       expect(last_response.location).to include("/profile/")
     end

  end
end
