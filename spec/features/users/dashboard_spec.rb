require "rails_helper"

RSpec.describe "User Dashboard" do 
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

  # it 'will have a section that lists viewing parties' do 
  #   within "#party#{@party1.id}" do 
  #     expect(page).to have_content("Invited")
  #     expect(page).to have_content(Date.today)
  #     expect(page).to have_content(Time.now.strftime("%I:%M:%S"))
  #   end 
    
  #   within "#party#{@party2.id}" do 
  #     expect(page).to have_content("Hosting")
  #     expect(page).to have_content(Time.now.strftime("%I:%M:%S"))
  #   end
  # end

  it 'see the viewing parties that the user has been invited to with party information' do
    save_and_open_page
    expect(page).to have_content("movie.image_url")
    expect(page).to have_link(movie.title)
    expect(page).to have_content("#{@party1.party_date}")
    expect(page).to have_content("#{@party1.party_time}")
    expect(page).to have_content("Host: #{@user_2.name}")
    expect(page).to have_content("#{@user_1.name}, bold: true")
  end

  it 'see the viewing parties that the user has created with the following details' do
    expect(page).to have_content("movie.image_url")
    expect(page).to have_link(movie.title)
    expect(page).to have_content("#{@party1.party_date}")
    expect(page).to have_content("#{@party1.party_time}")
    expect(page).to have_content("#{@user_1.name} is the host")
    expect(page).to have_content("#{@user_3.name} is invited")
  end
end