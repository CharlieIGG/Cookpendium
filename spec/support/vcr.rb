# frozen_string_literal: true

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('<API_KEY>') { ENV['OPENAI_API_KEY'] }
  config.before_record do |interaction|
    # Replace the sensitive header with a placeholder
    interaction.request.headers['Openai-Organization'] = '<SENSITIVE>'
  end
end
