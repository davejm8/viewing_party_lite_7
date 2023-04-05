require "rails_helper"

RSpec.describe "User Dashboard" do 
  before :each do
    movie_response = File.read('spec/fixtures/movie.json')
    stub_request(:get, "https://api.themoviedb.org/3/movie/238?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: movie_response)
    shawshank_response = File.read('spec/fixtures/shawshank.json')
    stub_request(:get, "https://api.themoviedb.org/3/movie/278?api_key=#{ENV['MOVIE_DB_KEY']}")
      .to_return(status: 200, body: shawshank_response)

    @user_1 = create(:user)
    @user_2 = create(:user)
    @user_3 = create(:user)
    @user_4 = create(:user)
    @movie_1 = Movie.new(JSON.parse(movie_response, symbolize_names: true))
    @movie_2 = Movie.new(JSON.parse(shawshank_response, symbolize_names: true))
    
    @viewing_party_1 = ViewingParty.create!(duration: '180', party_date: Date.today, party_time: Time.now, movie_id: @movie_1.id, host_id: @user_1.id)
    @viewing_party_2 = ViewingParty.create!(duration: '150', party_date: Date.today, party_time: Time.now, movie_id: @movie_2.id, host_id: @user_2.id)

    @user_party_1 = UserParty.create!(user_id: @user_1.id, viewing_party_id: @viewing_party_1.id)
    @user_party_2 = UserParty.create!(user_id: @user_1.id, viewing_party_id: @viewing_party_2.id)
    @user_party_3 = UserParty.create!(user_id: @user_2.id, viewing_party_id: @viewing_party_2.id)
    
    log_in

    visit "users/#{@user_1.id}"
  end

  it "will have the user's name" do 
    expect(page).to have_content(@user_1.name)
  end 

  it 'will have a button to Discover Movies' do 
    expect(page).to have_link("Discover Movies")

    click_on "Discover Movies"

    expect(current_path).to eq("/users/#{@user_1.id}/discover")
  end

  it 'displays the viewing party information' do
    within "#party-#{@movie_1.id}" do
      expect(page).to have_content(@viewing_party_1.party_time.strftime('%I:%M%p'))
      expect(page).to have_content(@viewing_party_1.party_date.strftime('%B %d, %Y'))
    end
  end

  it 'displays the attendees' do
    within "#party-#{@movie_1.id}" do
      expect(page).to have_content("#{@user_2.name}")
      expect(page).to have_content("#{@user_1.name}")
      expect(page).to_not have_content("#{@user_3.name}")
    end
  end

  it 'the movie title is a link to the movies show page' do
    expect(page).to have_link("#{@movie_1.title}")
  end
end