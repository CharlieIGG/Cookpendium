require 'rails_helper'

RSpec.describe 'Passwords', type: :system do
  let_it_be(:user) { create(:user) }

  describe 'Reset' do
    it 'can get an email to recover their password' do
      expect do
        visit new_user_password_path

        fill_in User.human_attribute_name(:email), with: user.email
        click_button I18n.t('devise.passwords.send_email_cta_button')

        expect(page).to have_content(I18n.t('devise.passwords.send_instructions'))
      end.to have_enqueued_job.on_queue('mailers')
    end

    it 'can reset their password' do
      visit edit_user_password_path(user, reset_password_token: user.send_reset_password_instructions)

      fill_in I18n.t('devise.passwords.new_password'), with: 'new_password'
      fill_in I18n.t('devise.passwords.new_password_confirmation'), with: 'new_password'
      click_button I18n.t('devise.passwords.update_cta')

      expect(page).to have_content(I18n.t('devise.passwords.updated'))

      click_link user.username
      click_link I18n.t('devise.sessions.sign_out')

      expect(page).to have_content(I18n.t('devise.sessions.signed_out'))

      visit new_user_session_path

      fill_in User.human_attribute_name(:email), with: user.email
      fill_in User.human_attribute_name(:password), with: 'new_password'
      click_button I18n.t('devise.sessions.sign_in')

      expect(page).to have_content(I18n.t('devise.sessions.signed_in'))
    end
  end
end
