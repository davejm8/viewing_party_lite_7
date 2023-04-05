require 'rails_helper'

RSpec.describe 'movies show page' do
  before(:each) do
    @user_1 = create(:user)
    @party1 = create(:viewing_party)
    @party2 = create(:viewing_party)
    create(:user_party, user: @user_1, viewing_party: @party1)
    create(:user_party, user: @user_1, viewing_party: @party2)

    top_20_response = File.read('spec/fixtures/top_movies.json')
    stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: top_20_response)

    search_results = File.read('spec/fixtures/godfather_search.json')
    stub_request(:get, "https://api.themoviedb.org/3/search/movie?query=Godfather&api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: search_results)

    stub_request(:get, "https://api.themoviedb.org/3/search/movie?api_key=#{ENV['MOVIE_DB_KEY']}&query=")
      .to_return(status: 200, body: '{"results": []}')
    
    movie_response = File.read('spec/fixtures/movie.json')
    stub_request(:get, "https://api.themoviedb.org/3/movie/238?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: movie_response)
    @movie = Movie.new(JSON.parse(movie_response, symbolize_names: true))

    actor_response = File.read('spec/fixtures/actors.json')
    stub_request(:get, "https://api.themoviedb.org/3/movie/238/credits?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: actor_response)

    review_response = File.read('spec/fixtures/reviews.json')
    stub_request(:get, "https://api.themoviedb.org/3/movie/238/reviews?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: review_response)
  end

  it 'has a back button' do
    visit "/users/#{@user_1.id}/movies/#{@movie.id}"

    expect(page).to have_link('Back')
  end

  it 'has a button to create a viewing party' do
    visit "/users/#{@user_1.id}/movies/#{@movie.id}"

    expect(page).to have_link("Create Viewing Party")
  end

  it "fail to create a viewing party if the user is not login" do
    visit "/users/#{@user_1.id}/movies/#{@movie.id}"

    click_on("Create Viewing Party")
    expect(current_path).to eq("/users/#{@user_1.id}/movies/#{@movie.id}")
    expect(page).to have_content("You must be logged in or registered to create a movie party")
  end

  it 'has the movie attributes' do
    visit "/users/#{@user_1.id}/movies/#{@movie.id}"

    expect(page).to have_content("Title: #{@movie.title}")
    expect(page).to have_content("Vote Average: #{@movie.vote_average}")
    expect(page).to have_content("Run Time: #{@movie.runtime}")
    expect(page).to have_content("Summary: #{@movie.summary}")
    expect(page).to have_content("Drama")
    expect(page).to have_content("Crime")
  end

  it 'has the first 10 actors in the cast' do
    visit "/users/#{@user_1.id}/movies/#{@movie.id}"

    within '#actors' do
      expect(page).to have_content('Marlon Brando')
      expect(page).to have_content('Al Pacino')
      expect(page).to have_content('James Caan')
      expect(page).to have_content('Robert Duvall')
      expect(page).to have_content('Richard S. Castellano')
      expect(page).to have_content('Diane Keaton')
      expect(page).to have_content('Talia Shire')
      expect(page).to have_content('Gianni Russo')
      expect(page).to have_content('Sterling Hayden')
      expect(page).to have_content('Al Lettieri')
    end

    expect(page).to_not have_content('Abe Vigoda')
  end

  it 'it has the total count of reviews' do
    visit "/users/#{@user_1.id}/movies/#{@movie.id}"

      within '#reviews' do
        expect(page).to have_content("Author: futuretv")
        expect(page).to have_content("The casting for this film has been considered by many to be the best")
        expect(page).to have_content("Rating: 10.0")

        expect(page).to have_content("Author: crastana")
        expect(page).to have_content("A masterpiece by the young and talented Francis Ford")
        expect(page).to have_content("Rating: 10.0")

        expect(page).to have_content("Total Reviews: 2")
      end
    expect(page).to_not have_content("Author: jason")
  end
end