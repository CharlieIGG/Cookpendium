# frozen_string_literal: true

module CapybaraSmartSelectHelper
  # Selects a value from a dropdown or autocomplete field.
  #
  # @param value [String] The value to select.
  # @param from [String] The label text of the field.
  # @param wrapper_css_selector [String] (optional) The CSS selector of the wrapper element that contains the field.
  #                                      Defaults to 'form-group'.
  # @param create [Boolean] (optional) Whether the creation of a new option is expected if the value is not found in the dropdown.
  #                             Defaults to false. See more on this in the SmartSelectController, and the TomSelect documentation.
  def smart_select(value, from:, wrapper_css_selector: 'form-group', create: false)
    target_text = create ? /#{I18n.t('forms.add_new')} #{Regexp.quote(value)}/i : /#{Regexp.quote(value)}/i
    container = find(:label, text: from).ancestor(wrapper_css_selector)
    within(container) do
      type_value(value, target_text)
      click_on_option(target_text)
    end
  end

  private

  def type_value(value, _target_text)
    input = find('.ts-control input')
    input.native.clear
    sleep 0.1 # Add a small delay to ensure the element is ready
    input.native.send_keys(value)
    input.execute_script('arguments[0].focus();', input.native)
  end

  def click_on_option(target_text)
    expect(page).to have_selector('.ts-dropdown .ts-dropdown-content .option', text: target_text)
    option = find('.ts-dropdown .ts-dropdown-content .option', text: target_text)
    option.click
  end
end
