require 'rails_helper'

RSpec.describe 'User Registration', type: :system do
  describe 'with valid data' do
    it 'creates a user record and sends a confirmation email' do
      expect do
        visit new_user_registration_path

        fill_in I18n.t('activerecord.attributes.user.email'), with: 'test@example.com'
        fill_in I18n.t('activerecord.attributes.user.password'), with: 'password'
        fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: 'password'
        click_button I18n.t('devise.registrations.sign_up')

        expect(User.count).to eq(1)
      end.to change { Sidekiq::Worker.jobs.size }.by(1)
    end
  end

  describe 'with invalid data' do
    it 'does not create a user record and shows a validation error' do
      visit new_user_registration_path

      click_button I18n.t('devise.registrations.sign_up')

      expect(User.count).to eq(0)
      resource = User.create # reproduces invalid user creation attempt
      expect(page).to have_content(I18n.t('errors.messages.not_saved',
                                          count: resource.errors.count,
                                          resource: resource.class.model_name.human.downcase), wait: 1)
    end
  end

  describe 'confirming a user' do
    it 'allows a user to confirm their email address' do
      user = create(:user, password: 'password', confirmed_at: nil)

      visit user_confirmation_path(confirmation_token: user.confirmation_token)

      expect(page).to have_content(I18n.t('devise.confirmations.confirmed'))
      expect(user.reload.confirmed_at).not_to be_nil
    end
  end
end
