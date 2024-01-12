require 'rails_helper'

RSpec.describe 'Managing Users', type: :system do # rubocop:disable Metrics/BlockLength
  let_it_be(:superadmin) { create(:user, :superadmin) }
  let_it_be(:admin) { create(:user, :admin) }
  let_it_be(:user) { create(:user) }

  context 'as a superadmin' do
    before do
      login_as superadmin
    end

    it 'can edit and update any user' do
      target_user = create(:user)
      visit edit_user_path(target_user)

      expect(page).to have_field(User.human_attribute_name('username'), with: target_user.username, disabled: true)
      expect(page).to have_button(I18n.t('forms.save'), disabled: true)
    end
  end

  context 'as an admin' do
    before do
      login_as admin
    end

    it 'can edit and update non-admin users' do
      target_user = create(:user)
      visit edit_user_path(target_user)

      expect(page).to have_field(User.human_attribute_name('username'), with: target_user.username, disabled: true)
      expect(page).to have_button(I18n.t('forms.save'), disabled: true)
    end

    it 'cannot edit and update admin users' do
      admin_user = create(:user, :admin)
      visit edit_user_path(admin_user)

      expect(page).not_to have_button(I18n.t('forms.save'), disabled: true)
      expect(page).to have_content(I18n.t('pundit.unauthorized.default'))
    end
  end

  context 'as a regular user' do
    before do
      login_as user
    end

    it 'can edit and update themselves' do
      visit edit_user_path(user)

      expect(page).to have_field(User.human_attribute_name('username'), with: user.username, disabled: true)
      expect(page).to have_button(I18n.t('forms.save'), disabled: true)
    end

    it 'cannot edit and update other users' do
      other_user = create(:user)
      visit edit_user_path(other_user)

      expect(page).not_to have_button(I18n.t('forms.save'), disabled: true)
      expect(page).to have_content(I18n.t('pundit.unauthorized.default'))
    end
  end
end
