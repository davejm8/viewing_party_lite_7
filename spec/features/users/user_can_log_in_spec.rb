require 'rails_helper'

RSpec.describe "Logging In" do
  it "can log in with valid credentials" do
    user = User.create!(name: "Bob", email: "user@example.com", password: "test1")

    visit root_path

    click_on "Log In"

    expect(current_path).to eq(login_path)

    fill_in :email, with: user.email
    fill_in :password, with: user.password

    click_on "Log In"
    expect(current_path).to eq("/users/#{user.id}")
  end

  it "fail to log in with invalid credentials" do
    user = User.create!(name: "Bob", email: "user@example.com", password: "test1")

    visit root_path

    click_on "Log In"

    expect(current_path).to eq(login_path)
    
    fill_in :email, with: user.email
    fill_in :password, with: "test2"

    click_on "Log In"

    expect(current_path).to eq(login_path)

    expect(page).to have_content("Password Mismatch")
  end
end