require 'rails_helper'

RSpec.describe 'Password Reset', type: :system do
  let_it_be(:user) { create(:user) }

  it 'allows a user to recover their password' do
    visit new_user_password_path

    fill_in User.human_attribute_name(:email), with: user.email
    click_button I18n.t('devise.passwords.send_email_cta_button')

    expect(page).to have_content(I18n.t('devise.passwords.send_instructions'))
    expect(ActionMailer::Base.deliveries.count).to eq(1)

    pending 'Test failing mysteriously, see opened SO Thread: https://stackoverflow.com/questions/77809435/rspec-system-tests-reset-password-token-is-invalid'

    email = ActionMailer::Base.deliveries.last
    html = Nokogiri::HTML(email.body.to_s)
    target_url = html.at("a:contains('#{I18n.t('devise.passwords.email.link_cta')}')")['href']

    visit target_url

    fill_in I18n.t('devise.passwords.new_password'), with: 'new_password'
    fill_in I18n.t('devise.passwords.new_password_confirmation'), with: 'new_password'
    click_button I18n.t('devise.passwords.update_cta')

    expect(page).to have_content(I18n.t('devise.passwords.updated'))

    click_link I18n.t('devise.sessions.sign_out')

    visit new_user_session_path

    fill_in User.human_attribute_name(:email), with: user.email
    fill_in User.human_attribute_name(:password), with: 'new_password'
    click_button I18n.t('devise.sessions.sign_in')

    expect(page).to have_content(t('devise.sessions.signed_in'))
  end
end
