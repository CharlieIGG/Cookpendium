# frozen_string_literal: true

# == Schema Information
#
# Table name: measurement_units
#
#  id           :bigint           not null, primary key
#  abbreviation :string
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class MeasurementUnit < ApplicationRecord
  after_commit :auto_abbreviate_later

  include AutoTranslateable

  translates :name, :abbreviation

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :abbreviation, uniqueness: { case_sensitive: false }, allow_blank: true

  scope :by_name, -> { order(:name) }

  def auto_abbreviate
    return if abbreviation&.length&.positive?

    AITools::MeasurementUnitAbbreviator.call(name, locale: I18n.locale)
  end

  def auto_abbreviate_later
    return if abbreviation&.length&.positive?

    AutoAbbreviateUnitJob.perform_later(id, locale: I18n.locale)
  end
end
