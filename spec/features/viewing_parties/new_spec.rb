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
  end

  it 'displays the movie title' do
    visit "/users/#{@user_1.id}/movies/#{@movie.id}/viewing_parties/new"

    expect(page).to have_content("#{@movie.title}")
  end
end