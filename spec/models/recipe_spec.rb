# == Schema Information
#
# Table name: recipes
#
#  id                   :bigint           not null, primary key
#  cooking_time_minutes :integer
#  description          :text             not null
#  prep_time_minutes    :integer
#  serving_unit         :string
#  servings             :integer
#  title                :string           not null
#  vegan                :boolean
#  vegetarian           :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let(:recipe_title) { 'Fruit Salad' }
  let(:recipe_description) { 'A delicious fruit salad' }
  let(:recipe) { I18n.with_locale(:en) { create(:recipe, title: recipe_title, description: recipe_description) } }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  it 'is translatable' do
    I18n.locale = :de
    expect(recipe.title).to eq(nil)
    recipe.update!(title: 'Obstsalat', description: 'Ein leckerer Obstsalat')
    expect(recipe.title).to eq('Obstsalat')
    I18n.locale = :en
    expect(recipe.title).to eq(recipe_title)
  end

  it 'can attach an image' do
    image = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'sample_image.png'), 'image/png')
    recipe.image.attach(image)
    expect(recipe.image).to be_attached
  end

  it 'should automatically call the auto_translate_later method after creating or updating' do
    expect do
      create(:recipe)
    end.to have_enqueued_job(AutoTranslateJob)

    expect(recipe).to receive(:auto_translate_later)
    recipe.update!(title: 'Strawberry Salad', description: 'A delicious strawberry salad')
  end
end
