class DashboardController < ApplicationController
  before_filter :require_login

  protected
  def require_login
    unless current_user
      redirect_to login_path
    end
  end
end
