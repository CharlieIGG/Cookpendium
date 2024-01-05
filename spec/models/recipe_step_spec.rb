# == Schema Information
#
# Table name: recipe_steps
#
#  id          :bigint           not null, primary key
#  description :text             not null
#  instruction :text
#  step_number :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  recipe_id   :bigint           not null
#
# Indexes
#
#  index_recipe_steps_on_recipe_id  (recipe_id)
#
# Foreign Keys
#
#  fk_rails_...  (recipe_id => recipes.id)
#
# spec/models/recipe_step_spec.rb
require 'rails_helper'

RSpec.describe RecipeStep, type: :model do
  it { should validate_presence_of(:instruction) }
  it { should validate_presence_of(:step_number) }
  it { should validate_numericality_of(:step_number).only_integer.is_greater_than(0) }

  it 'is translatable' do
    recipe = FactoryBot.create(:recipe)
    recipe_step = RecipeStep.create!(recipe:, instruction: 'Mix the {{ingredient_name}} into the bowl',
                                     description: 'Mix the {{ingredient_name}} into the bowl', step_number: 1)
    I18n.locale = :de
    expect(recipe_step.instruction).to eq(nil)
    recipe_step.update!(instruction: 'Mische {{ingredient_name}} in die Schüssel',
                        description: 'Mische {{ingredient_name}} in die Schüssel')
    I18n.locale = :en
    expect(recipe_step.instruction).to eq('Mix the {{ingredient_name}} into the bowl')
  end

  it 'has a valid factory' do
    expect(FactoryBot.build(:recipe_step)).to be_valid
  end
end
