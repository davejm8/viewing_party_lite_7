require 'rails_helper'

RSpec.describe ViewingParty, type: :model do
  describe 'validations' do
    it { should validate_presence_of :movie_id }
  end

  describe 'relationships' do
    it { should have_many :user_parties }
    it { should have_many(:users).through(:user_parties) }
  end

  describe 'instance methods' do
    before :each do
      json_response = File.read('spec/fixtures/movie.json')
      stub_request(:get, "https://api.themoviedb.org/3/movie/1?api_key=31a91f66ec30b23d3703ba205b86f0bb")
      .to_return(status: 200, body: json_response, headers: {})
      @user_1 = create(:user)
      @user_2 = create(:user)
      @user_3 = create(:user)
  
      @party1 = create(:viewing_party, host_id: @user_2.id)
      @party2 = create(:viewing_party, host_id: @user_1.id)
  
      create(:user_party, user: @user_1, viewing_party: @party1 )
      create(:user_party, user: @user_2, viewing_party: @party1 )
      
      create(:user_party, user: @user_1, viewing_party: @party2 )
      create(:user_party, user: @user_3, viewing_party: @party2 )
    end
  

    it '#movie_info' do
     expect(@party1.movie_info.title).to eq("The Godfather")
    end
  end
end