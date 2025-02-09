class UsersController < ApplicationController
  before_action :require_user, only: [:show]

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
    @user = User.new(user_params)
    if User.exists?(email: @user.email)
      flash[:notice] = "Email already exists"
      render :new
    elsif @user.save
      redirect_to "/users/#{@user.id}"
    else
      render :new
    end
  end

  def login_form
    
  end

  def login
    user = User.find_by(email: params[:email])
    if user.nil?
      flash[:notice] = "Invalid Credentials"
      redirect_to '/login'
    elsif user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to "/users/#{user.id}"
    else
      flash[:notice] = "Invalid Credentials"
      redirect_to '/login'
    end
  end

  private
    def user_params
      params.permit(:name, :email, :password, :password_confirmation)
    end
end