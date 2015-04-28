class UserAuthenticationController < ApplicationController
  def login
    @user = User.new
  end

  def login_form
    begin
      @user = User.find_by(username: params[:user][:username])
      if @user && UserAuthentication.instance.authenticate(@user, params[:user][:password])
        flash_success 'Welcome ' + @user.username
        set_session @user
        redirect_to dashboard_path
      else
        user_not_found
      end
    rescue Mongoid::Errors::DocumentNotFound
      user_not_found
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def set_session user
    session[:user_id] = user.id.to_s
  end

  def user_not_found
    flash_error 'User not found'
    redirect_to login_path
  end
end
