class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user


  def current_user
    begin
      if session[:user_id]
        User.find(session[:user_id])
      else
        nil
      end
    rescue Mongoid::Errors::DocumentNotFound
      nil
    end
  end

  protected
  def flash_success(message)
    flash[:success] = message
  end

  def flash_error(message)
    flash[:error] = message
  end
end
