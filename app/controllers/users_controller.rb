class UsersController < ApplicationController
  skip_before_action :ensure_user_has_username, only: %i[edit update]
  before_action :set_user, only: %i[edit update]
  before_action :authorize_user, only: %i[edit update]

  def edit
    @suggested_username = generate_suggested_username if current_user.username.blank?
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user
    authorize @user
  end

  def user_params
    params.require(:user).permit(:username)
  end

  def generate_suggested_username
    Faker::Food.dish.split(' ').map(&:capitalize).join + Faker::Number.unique.number(digits: 3).to_s
  end
end
