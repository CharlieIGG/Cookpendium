# frozen_string_literal: true

# This is a dummy model that includes the AutoTranslateable module
# used for testing model-agnostic translation services and jobs
class AutoTranslateableDummyModel < ApplicationRecord
  self.table_name = 'recipes'
  include AutoTranslateable
  translates :title, :description
end
