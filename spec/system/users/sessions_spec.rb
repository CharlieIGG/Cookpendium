require 'rails_helper'

RSpec.describe 'User Sessions', type: :system do
  describe 'Login' do
    it 'is successful with valid data' do
      user = create(:user, password: 'password')
      visit new_user_session_path

      fill_in I18n.t('activerecord.attributes.user.email'), with: user.email
      fill_in I18n.t('activerecord.attributes.user.password'), with: user.password
      click_button I18n.t('devise.sessions.sign_in')

      expect(page).to have_text(I18n.t('devise.sessions.signed_in'))
    end

    it 'is unsuccessful with invalid data and renders a flash alert' do
      visit new_user_session_path

      fill_in I18n.t('activerecord.attributes.user.email'), with: 'invalid@example.com'
      fill_in I18n.t('activerecord.attributes.user.password'), with: 'password'
      click_button I18n.t('devise.sessions.sign_in')

      expect(page).to have_content(I18n.t('devise.failure.invalid',
                                          authentication_keys: I18n.t('activerecord.attributes.user.email')))
    end

    it 'allows user to navigate to sign up path' do
      visit new_user_session_path

      click_link I18n.t('devise.shared.links.sign_up')

      expect(page).to have_current_path(new_user_registration_path)
    end
  end
end
