require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
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

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
  end
  
  describe 'relationships' do
    it { should have_many :user_parties }
    it { should have_many(:viewing_parties).through(:user_parties) }
  end

  describe "instance methods" do
    it '#find_all_party_hosted' do
      expect(@user_1.find_all_party_hosted).to eq([@party2])
    end

    it '#find_all_party_not_hosted' do
      expect(@user_1.find_all_party_not_hosted).to eq([@party1])
    end
  end
end