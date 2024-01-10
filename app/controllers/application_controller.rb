class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!
  before_action :ensure_user_has_username

  private

  def ensure_user_has_username
    return unless current_user && current_user.username.blank?

    redirect_to edit_user_path(current_user)
  end
end
