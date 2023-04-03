require 'rails_helper'

RSpec.describe "'/register'", type: :feature do
  describe "When I visit the register page" do
    before :each do
      visit "/register"
    end

    it "Should have a form to register a new user" do
      expect(page).to have_content("Viewing Party")
      expect(page).to have_content("Register a New User")
      expect(page).to have_field(:name)
      expect(page).to have_field(:email)
      expect(page).to have_field(:password)
      expect(page).to have_field(:password_confirmation)
      expect(page).to have_button("Create New User")

      password = "test"
      fill_in :name, with: "David"
      fill_in :email, with: "David@example.com"
      fill_in :password, with: password
      fill_in :password_confirmation, with: password
      click_button("Create New User")

      expect(current_path).to eq("/users/#{User.last.id}")
      expect(page).to have_content("David's Dashboard")
    end

    it "doesn't create a new user if name is missing" do
      fill_in :email, with: "John@example.com"

      click_button("Create New User")
    end

    it "doesn't create a new user if email has already been used" do
      User.create(name: "Bob", email: "bob123@example.com")

      fill_in :name, with: "John"
      fill_in :email, with: "bob123@example.com" 

      click_button("Create New User")
    end

    it "doesn't create a new user if password is missing" do
      fill_in :password, with: nil

      click_button("Create New User")
      
      expect(current_path).to eq('/register')
      expect(page).to have_content("Password can't be blank")
    end

    it "doesn't create a new user if password_confirmation is mismatch" do
      password = "test1"
      
      fill_in :password, with: "test1"
      fill_in :password_confirmation, with: "test2"

      click_button("Create New User")

      expect(current_path).to eq('/register')
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end
end