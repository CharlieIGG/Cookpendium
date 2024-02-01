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
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  it 'is translatable' do
    recipe = Recipe.create!(title: 'Fruit Salad', description: 'A delicious fruit salad')
    I18n.locale = :de
    expect(recipe.title).to eq(nil)
    recipe.update!(title: 'Obstsalat', description: 'Ein leckerer Obstsalat')
    I18n.locale = :en
    expect(recipe.title).to eq('Fruit Salad')
  end

  it 'can attach an image' do
    recipe = Recipe.create!(title: 'Fruit Salad', description: 'A delicious fruit salad')
    image = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'sample_image.png'), 'image/png')
    recipe.image.attach(image)
    expect(recipe.image).to be_attached
  end
end
