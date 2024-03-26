# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  unconfirmed_email      :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  validates :username, uniqueness: true, allow_blank: true
  validates :email, uniqueness: true, presence: true

  has_many :recipes, through: :roles, source: :resource, source_type: :Recipe

  after_create :assign_default_role

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    return user if user

    User.create(email: data['email'], password: Devise.friendly_token[0, 20]).tap(&:confirm)
  end

  def admin?
    has_role?(:admin)
  end

  def author?(resource)
    has_role?(:author, resource)
  end

  private

  def assign_default_role
    add_role(:basic_user) if roles.blank?
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
