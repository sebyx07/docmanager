class UserAuthenticationController < ApplicationController
  def login
    @user = User.new
  end

  def login_form
    begin
      @user = User.find_by(username: params[:user][:username])
      if @user && UserAuthenticationService.instance.authenticate(@user, params[:user][:password])
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

  def register
    @user = User.new
  end

  def register_form
    @user = User.new(user_params)
    if @user.set_password && @user.save
      set_session @user
      flash_success 'Welcome to Doc Manager'
      redirect_to dashboard_path
    else
      flash_error @user.errors.full_messages
      render :register
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

  def user_params
    params.require(:user).permit(:username, :password_temp, :password_temp_confirm)
  end
end
