# frozen_string_literal: true

module CapybaraSmartSelectHelper
  def smart_select(value, from:, wrapper_css_selector: 'form-group', create: false)
    target_text = create ? /#{I18n.t('forms.add_new')} #{Regexp.quote(value)}/i : /#{Regexp.quote(value)}/i
    container = find(:label, text: from).ancestor(wrapper_css_selector)
    within(container) do
      find('.ts-control input').send_keys(value)
      target_option = all('.ts-dropdown .ts-dropdown-content .option', text: target_text)[0]
      sleep 0.3 unless target_option
      target_option.click
    end
    sleep 0.3 if create
  end
end
