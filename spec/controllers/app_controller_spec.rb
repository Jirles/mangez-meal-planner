require 'spec_helper'

describe "AppController" do
  before do
    visit "/"
  end

  it 'responds with a 200 status code' do
    expect(page.status_code).to eq(200)
  end

  it "welcomes the user" do
    expect(page.body).to include("Welcome to Mangez")
  end 

end
