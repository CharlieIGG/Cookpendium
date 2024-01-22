require 'rails_helper'

RSpec.describe 'Passwords', type: :system do
  let_it_be(:user) { create(:user) }

  describe 'Reset' do
    it 'can get an email to recover their password' do
      visit new_user_password_path

      fill_in User.human_attribute_name(:email), with: user.email
      click_button I18n.t('devise.passwords.send_email_cta_button')

      expect(page).to have_content(I18n.t('devise.passwords.send_instructions'))
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it 'can reset their password' do
      User.send_reset_password_instructions(email: user.email)

      email = ActionMailer::Base.deliveries.last
      html = Nokogiri::HTML(email.body.to_s)
      target_url = html.at("a:contains('#{I18n.t('devise.passwords.email.link_cta')}')")['href']
      relative_target_url = target_url.split('localhost:3000').last # non-relative paths are causing Selenium to send net::ERR_CONNECTION_REFUSED

      visit relative_target_url

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
