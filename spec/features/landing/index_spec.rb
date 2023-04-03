require 'rails_helper'

RSpec.describe 'landing page' do
  before :each do
    @user1 = User.create!(name: 'Bob', email: 'blahblah@blah.com', password: "test")
    @user2 = User.create!(name: 'Steve', email: 'steve@steve.com', password: "test")

    @party1 = ViewingParty.create!(duration: 120, party_date: '2021-03-20', party_time: '12:00:00', movie_id: 1)
    @party2 = ViewingParty.create!(duration: 60, party_date: '2021-04-20', party_time: '09:00:00', movie_id: 2)

    @user_party1 = UserParty.create!(user_id: @user1.id, viewing_party_id: @party1.id)

    visit '/'
  end

  it 'displays the title of the application' do
    expect(page).to have_content("Welcome to Viewing Party!")
  end

  it 'displays a button to create a new user' do
    expect(page).to have_button("Register New User")

    click_button "Register New User"
    expect(current_path).to eq("/register")
  end

  it 'has a list of users and their names are links to their show page' do
    expect(page).to have_link(@user1.name)
    expect(page).to have_link(@user2.name)
  end

  it 'has a link to go back to the landing page' do
    expect(page).to have_link("Home")

    click_link "Home"
    
    expect(current_path).to eq("/")
  end
end