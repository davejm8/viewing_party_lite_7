require 'rails_helper'

RSpec.describe "Logging Out" do

  it "can recognize a session" do
    user = User.create!(name: "Bob", email: "user@example.com", password: "test1")

    visit root_path

    click_on "Log In"
    expect(current_path).to eq(login_path)

    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on("Log In")
    expect(current_path).to eq("/users/#{user.id}")

    visit root_path
    
    expect(page).to_not have_link("Log In")
    expect(page).to have_link("Log Out")
  end

  it "can log out a user" do
    user = User.create!(name: "Bob", email: "user@example.com", password: "test1")

    visit root_path

    click_on "Log In"
    expect(current_path).to eq(login_path)

    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_on("Log In")
    expect(current_path).to eq("/users/#{user.id}")

    visit root_path
    click_on("Log Out")

    expect(current_path).to eq(root_path)
    expect(page).to have_link("Log In")
    expect(page).to_not have_link("Log Out")
  end
end