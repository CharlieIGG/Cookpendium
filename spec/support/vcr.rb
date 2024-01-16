# frozen_string_literal: true

require 'vcr'

VCR.configure do |config|
  config.ignore_hosts '127.0.0.1', 'localhost', '0.0.0.0', ENV.fetch('SELENIUM_REMOTE_HOST', 'selenium')
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('<API_KEY>') { ENV['OPENAI_API_KEY'] }
  config.before_record do |interaction|
    # Replace the sensitive header with a placeholder
    interaction.request.headers['Openai-Organization'] = '<SENSITIVE>'
  end
end
