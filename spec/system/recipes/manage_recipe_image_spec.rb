# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Managing images for a recipe', type: :system do
  let_it_be(:user) { create(:user) }

  before(:each) do
    login_as user
  end

  after(:context) do
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end

  describe 'during recipe creation' do
    it 'allows the user to upload and associate an image with the recipe' do
      visit new_recipe_path

      users_title = 'My Title'
      users_description = 'My Description'

      fill_in Recipe.human_attribute_name(:title), with: users_title
      fill_in Recipe.human_attribute_name(:description), with: users_description

      click_link I18n.t('recipes.add_image_cta')

      # Select an image file to upload
      attach_file I18n.t('recipes.select_image_cta'), Rails.root.join('spec', 'fixtures', 'sample_image.png'),
                  visible: false

      # Verify that the image preview is shown
      expect(page).to have_css('.recipe-image-preview')

      sleep 1 # HACK: otherwise modal doesn't dismiss on click
      click_button I18n.t('recipes.approve_image_cta')

      expect(page).not_to have_css('#imageModal') # Verify that the modal has closed
      # Verify that the recipe now has an associated image
      expect do
        click_button I18n.t('helpers.submit.create', model: Recipe.model_name.human)
        expect(page).to have_content(I18n.t('helpers.created.one', model: Recipe.model_name.human))
      end.to change(Recipe, :count).by(1)
      expect(Recipe.last.image.attached?).to be true
    end
  end
end
