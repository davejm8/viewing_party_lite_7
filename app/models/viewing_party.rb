class ViewingParty < ApplicationRecord
  validates_presence_of :movie_id

  has_many :user_parties
  has_many :users, through: :user_parties

  def movie_info
    MovieFacade.get_movie(self.movie_id)
    # binding.pry
  end
end
