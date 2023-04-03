class User < ApplicationRecord
  validates_presence_of :name, :email
  validates_uniqueness_of :email
  validates_presence_of :password

  has_secure_password
  has_many :user_parties
  has_many :viewing_parties, through: :user_parties
end