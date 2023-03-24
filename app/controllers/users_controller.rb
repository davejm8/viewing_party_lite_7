class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @viewing_parties = @user.viewing_parties
    @viewing_party_host = @user.find_all_party_hosted
    @viewing_party_not_host = @user.find_all_party_not_hosted
  end

  def new
    
  end

  def create
    user = User.new(user_params)
    if user.save
      redirect_to "/users/#{user.id}"
    end
  end

  private
    def user_params
      params.permit(:name, :email )
    end
end