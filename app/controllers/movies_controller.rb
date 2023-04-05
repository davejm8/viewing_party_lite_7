class MoviesController < ApplicationController
  # before_action :authorization, only: [:show]
  def show
      @user = User.find(params[:user_id])
      @movie = MovieFacade.get_movie(params[:id])
      @actors = MovieFacade.top_cast(params[:id])
      @reviews = MovieFacade.get_reviews(params[:id])
  end
end