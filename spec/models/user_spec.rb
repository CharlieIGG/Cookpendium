# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  ai_usage_this_week     :integer          default(0)
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
require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_uniqueness_of(:username) }
  it { should validate_uniqueness_of(:email).case_insensitive }

  describe 'class methods' do
    describe '.reset_ai_limits!' do
      it 'resets ai_usage_this_week to 0 for all users' do
        user1 = create(:user, ai_usage_this_week: 1)
        user2 = create(:user, ai_usage_this_week: 2)

        User.reset_ai_limits!

        expect(user1.reload.ai_usage_this_week).to eq(0)
        expect(user2.reload.ai_usage_this_week).to eq(0)
      end
    end
  end
end
