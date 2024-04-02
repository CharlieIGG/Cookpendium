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
  let(:recipe) { create(:recipe) }
  let(:instruction) { 'Mix the {{ingredient_name}} into the bowl' }
  let(:description) { 'Mix the {{ingredient_name}} into the bowl with all the other ingredients' }
  subject { build(:recipe_step, recipe:, instruction:, description:) }

  it { should validate_presence_of(:instruction) }
  it { should validate_presence_of(:step_number) }
  it { should validate_numericality_of(:step_number).only_integer.is_greater_than(0) }

  it 'is translatable' do
    expect(subject.instruction).to eq(instruction)
    I18n.locale = :de
    expect(subject.instruction).to eq(nil)
    subject.update!(instruction: 'Mische {{ingredient_name}} in die Schüssel',
                    description: 'Mische {{ingredient_name}} in die Schüssel')
    expect(subject.instruction).to eq('Mische {{ingredient_name}} in die Schüssel')
    I18n.locale = :en
    expect(subject.instruction).to eq(instruction)
  end

  it 'has a valid factory' do
    expect(FactoryBot.build(:recipe_step)).to be_valid
  end

  it 'should automatically call the auto_translate_later method after creating or updating' do
    expect do
      create(:recipe_step)
    end.to have_enqueued_job(AutoTranslateJob).with(kind_of(Integer), 'RecipeStep', source_locale: 'en', overwrite: nil)
    expect(subject).to receive(:auto_translate_later)
    subject.update!(instruction: 'A different instruction', description: 'A varied description')
  end
end
