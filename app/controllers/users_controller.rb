class UsersController < ApplicationController

  def show
    if current_user.present?
      @user = User.find(params[:id])
      @viewing_parties = @user.viewing_parties
      @parties_info = []
      @viewing_parties.each do |party|
        @parties_info << party.get_data
      end
    else
      flash[:alert] = "You must be logged in or registered to access your dashboard"
      redirect_to root_path
    end
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
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
      session[:user_id] = user.id
      redirect_to "/users/#{user.id}"
    else
      flash[:alert] = "Password Mismatch"
      render :login_form
    end
  end

  def logout_user
    session[:user_id] = nil
    redirect_to root_path
  end

  private
    def user_params
      params.permit(:name, :email, :password, :password_confirmation )
    end
end