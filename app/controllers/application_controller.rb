# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # def authorization
  #   if current_user.nil?
  #     flash[:alert] = "You must be logged in or registered to continue"
  #     redirect_to "/"
  #   else
  #     @user = User.find(params[:user_id])
  #     @user ||= current_user
  #   end
  # end
end
