class User < ApplicationRecord
  validates_presence_of :name, :email
  validates_uniqueness_of :email

  has_many :user_parties
  has_many :viewing_parties, through: :user_parties

  def find_all_party_hosted
    viewing_parties.where(host_id: self.id)
  end

  def find_all_party_not_hosted
    viewing_parties.where.not(host_id: self.id)
  end
end