class MovieFacade

  def self.top_rated
    MovieService.top_rated_movies[:results].map do |movie|
      Movie.new(movie)
    end
  end

  def self.get_movie(id)
    movie_data = MovieService.get_movie(id)
    Movie.new(movie_data)
  end
  
  def self.movie_search(query)
    MovieService.search(query)[:results].map do |movie|
      Movie.new(movie)
    end
  end

  def self.top_cast(id)
    MovieService.get_cast(id)[:cast][0..9].map do |data|
      Actor.new(data)
    end
  end

  def self.get_reviews(id)
    MovieService.get_reviews(id)[:results].map do |data|
      Review.new(data)
    end
  end

  def self.merchants_name
    MovieService.conn[:data].map do |merchant|
      info = merchant[:attributes]
      Merchant.new(info)
    end
  end
end