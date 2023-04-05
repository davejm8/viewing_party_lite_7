require 'rails_helper'

RSpec.describe 'new viewing party page' do
  before :each do
    @user_1 = create(:user)
    @user_2 = create(:user)
    @user_3 = create(:user)
    @user_4 = create(:user)

    
    json_response = File.read('spec/fixtures/movie.json')
    stub_request(:get, "https://api.themoviedb.org/3/movie/238?api_key=#{ENV['MOVIE_DB_KEY']}")
    .to_return(status: 200, body: json_response, headers: {})
    
    @movie = Movie.new(JSON.parse(json_response, symbolize_names: true))
    log_in
  end

  it 'displays the movie title' do
    visit "/users/#{@user_1.id}/movies/#{@movie.id}/viewing_parties/new"

    expect(page).to have_content("#{@movie.title}")
  end

  it 'has a form to create a new viewing party' do
    visit "/users/#{@user_1.id}/movies/#{@movie.id}/viewing_parties/new"

    expect(page).to have_content("Duration of Party")
    expect(page).to have_content("Date of Party")
    expect(page).to have_content("Time of Party")
    expect(page).to have_content("Invite Friends")
    expect(page).to have_field :duration, with: @movie.runtime
    expect(page).to have_field :party_date
    expect(page).to have_field :party_time
    expect(page).to have_unchecked_field(@user_2.name)
    expect(page).to have_unchecked_field(@user_3.name)
    expect(page).to have_unchecked_field(@user_4.name)
  end

  it 'creates a new viewing party when the form is filled out' do
    visit "/users/#{@user_1.id}/movies/#{@movie.id}/viewing_parties/new"

    within "#new_viewing_party" do
      fill_in :duration, with: 240
      fill_in :party_date, with: Date.today
      fill_in :party_time, with: Time.now + 1.hours

      check(@user_2.name)
      check(@user_3.name)

      click_button "Create Party"
    end
    expect(current_path).to eq("/users/#{@user_1.id}")
  end
end