require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_presence_of(:password)}
    it { should have_secure_password }

    # user = User.create(name: 'Meg', email: 'meg@test.com', password: 'password123', password_confirmation: 'password123')

    # expect(user).to_not have_attribute(:password)
    # expect(user.password_digest).to_not eq('password123')
  end
  
  describe 'relationships' do
    it { should have_many :user_parties }
    it { should have_many(:viewing_parties).through(:user_parties) }
  end
end