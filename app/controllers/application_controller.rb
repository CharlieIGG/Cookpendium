class ApplicationController < ActionController::Base
  include Pundit::Authorization

  protect_from_forgery
  before_action :authenticate_user!
  before_action :ensure_user_has_username

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def ensure_user_has_username
    return unless current_user && current_user.username.blank?

    redirect_to edit_user_path(current_user)
  end

  def user_not_authorized
    flash[:alert] = t('pundit.unauthorized.default')
    redirect_back(fallback_location: root_path)
  end
end
