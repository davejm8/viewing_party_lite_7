class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @viewing_parties = @user.viewing_parties
    @parties_info = []
    @viewing_parties.each do |party|
      @parties_info << party.get_data
    end
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      redirect_to "/users/#{user.id}"
    else
      flash[:alert] = user.errors.full_messages.join(", ")
      render :new
    end
  end

  def login_form

  end

  def login_user
    user = User.find_by(email: params[:email])

    if user.authenticate(params[:password])
      redirect_to "/users/#{user.id}"
    else
      flash[:alert] = "Password Mismatch"
      render :login_form
    end
  end

  private
    def user_params
      params.permit(:name, :email, :password, :password_confirmation )
    end
end