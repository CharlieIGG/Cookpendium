# frozen_string_literal: true

# Encapsulates representational logic for rendering a Recipe
class RecipeDecorator < BaseDecorator
  def self.name
    'Recipe' # Used to ensure that Rolify's has_role? works with decorate Recipes
  end

  def title_html
    return title unless draft?

    (title + content_tag(:span, I18n.t('recipes.draft'),
                         class: 'badge rounded-pill text-bg-warning text-light ms-2')).html_safe
  end

  def vegan_vegetarian_marker
    return unless vegan || vegetarian
    return vegan_marker if vegan

    vegetarian_marker
  end

  def cooking_time_minutes_marker
    return unless cooking_time_minutes.present?

    generate_marker(icon: 'skillet',
                    text: "#{cooking_time_minutes} #{I18n.t('time.mins')} #{Recipe.human_attribute_name('cooking_time_minutes')}")
  end

  def prep_time_minutes_marker
    return unless prep_time_minutes.present?

    generate_marker(icon: 'timer',
                    text: "#{prep_time_minutes} #{I18n.t('time.mins')} #{Recipe.human_attribute_name('prep_time_minutes')}")
  end

  def servings_marker
    return unless servings.present?

    generate_marker(icon: 'restaurant_menu', text: "#{servings} #{serving_unit}")
  end

  private

  def vegan_marker
    generate_marker(icon: 'temp_preferences_eco', text_class: 'text-success',
                    text: Recipe.human_attribute_name('vegan'))
  end

  def vegetarian_marker
    generate_marker(icon: 'eco', text_class: 'text-success', text: Recipe.human_attribute_name('vegetarian'))
  end

  def generate_marker(icon:, text:, text_class: 'text-info')
    <<~HTML.html_safe
      <div class="d-flex align-items-center justify-content-center my-1">
        <span class='material-symbols-outlined #{text_class} me-1'>#{icon}</span> #{text}
      </div>
    HTML
  end
end
