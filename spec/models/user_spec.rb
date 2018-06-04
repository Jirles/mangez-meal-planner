require 'spec_helper'

describe 'User' do
  before do
    @user = User.create(username: "testqueen", email: "all_hail@test.com", password: "supersecret")

    @mac_n_cheese = Recipe.create(name: "Mac 'n' Cheese", ingredients: "cheese, macaroni, milk, butter", instruction: "mix it together in a pot")
    @cobb_salad = Recipe.create(name: "Cobb Salad", ingredients: "lettuce greens, eggs, chicken, dressing of choice", instructions: "mix it together in a bowl")
  end

  it 'has a username, email, and secure password' do
    expect(@user.username).to eq("testqueen")
    expect(@user.email).to eq("all_hail@test.com")
    expect(@user.authenticate("supersecret")).to be_truthy
  end

  it 'does not initialize without a username, email, or password' do

    expect(User.create(username: "FAIL", email: "fail@ure.com")).to be_falsey
    expect{User.create(email: "fail@ure.com", password: "failyfail")}.to raise_error{ |error| expect(error).to be_a(ActiveRecord::StatementInvalid) }

    expect{User.create(username: "FAIL", password: "failyfail")}.to raise_error{ |error| expect(error).to be_a(ActiveRecord::StatementInvalid) }
  end

  it 'can have multiple recipes' do

  end
end
