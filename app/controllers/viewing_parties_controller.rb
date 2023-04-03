class ViewingPartiesController < ApplicationController
  def new
    @movie = MovieFacade.get_movie(params[:movie_id])
    @user = User.find(params[:user_id])
    @users = User.where("id != #{@user.id}")
  end

  def create
    @user = User.find(params[:user_id])
    @viewing_party = ViewingParty.create!(viewing_party_params)
    # @viewing_party.save
    @invited_users = User.where(id: params[:user_ids].reject(&:empty?))
    # binding.pry
    # @viewing_party.users = @invited_users
    UserParty.create!(user_id: @user.id, viewing_party_id: @viewing_party.id)

    redirect_to "/users/#{@user.id}"
  end

  private

  def viewing_party_params
    params.permit(:duration, :party_date, :party_time, :movie_id, :host_id)
  end
end