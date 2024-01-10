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
FactoryBot.define do
  factory :user do
    confirmation_sent_at { Time.now }
    confirmation_token { 'abc123' }
    confirmed_at { Time.now }
    email { Faker::Internet.email }
    encrypted_password { 'password123' }
    remember_created_at { Time.now }
    reset_password_sent_at { Time.now }
    reset_password_token { 'def456' }
    unconfirmed_email { Faker::Internet.email }
    username { Faker::Internet.username }
    created_at { Time.now }
    updated_at { Time.now }
  end
end
