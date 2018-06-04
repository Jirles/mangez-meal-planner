require 'spec_helper'

describe 'UserController' do
  context 'signup page' do
    it 'when a user is directed to the signup page they see a form' do
      visit '/signup'

      expect(page.status_code).to eq(200)
      expect(page.body).to include("</form>")
    end

  end
end
