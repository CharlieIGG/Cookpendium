# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AITools::AutoTranslator, type: :service do
  describe '#translate' do
    let(:attributes) { { title: 'Title', description: 'Description' } }
    let(:target_locales) { %w[de es] }
    let(:source_locale) { 'en' }
    let(:model_name) { 'Recipe' }
    let(:service_instance) { described_class.new(attributes, target_locales:, source_locale:, model_name:) }
    let(:assistant_messages) do
      [
        { role: 'system', content: 'Translate the following Recipe to the following ISO 639-1 languages: de,es.' },
        { role: 'system', content: 'The original language (ISO 639-1 code) is en.' },
        { role: 'system', content: 'Translate within the context of cooking recipes.' },
        { role: 'system',
          content: 'Return the translation as a JSON object, with the root containing the ISO 639-1 language code. '\
                   'Each key value should be an object with the translated attributes for the corresponding language' },
        { role: 'system', content: attributes.to_json }
      ]
    end

    it 'calls the OpenAI client with the proper parameters' do
      client = instance_double(OpenAI::Client)
      allow(client).to receive(:chat).and_return(
        { 'choices' => [{ 'message' => { 'content' => attributes.to_json } }] }
      )
      expect(OpenAI::Client).to receive(:new).and_return(client)
      expect(client).to receive(:chat).with({
                                              parameters: {
                                                model: 'gpt-3.5-turbo-1106',
                                                response_format: { type: 'json_object' },
                                                messages: assistant_messages,
                                                temperature: 0.5
                                              }
                                            })
      service_instance.send(:translate)
    end

    it 'returns the translated attributes' do
      VCR.use_cassette('openai/translate') do
        expect(service_instance.call).to eq(
          'de' => { 'title' => 'Titel', 'description' => 'Beschreibung' },
          'es' => { 'title' => 'Título', 'description' => 'Descripción' }
        )
      end
    end
  end
end
