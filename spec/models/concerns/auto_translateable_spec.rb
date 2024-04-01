# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AutoTranslateable, type: :model do
  let(:dummy_instance) do
    I18n.with_locale(:en) do
      AutoTranslateableDummyModel.create(title: 'Title', description: 'Description')
    end
  end

  describe '#translateable_attributes' do
    it 'returns the attributes that are declare as translateable, which have a value present in the current language but not the other(s)' do # rubocop:disable Layout/LineLength
      translated_attributes = { title: 'Title', description: 'Description' }

      expect(dummy_instance.translateable_attributes).to eq(translated_attributes)
      I18n.with_locale(:es) do
        expect(dummy_instance.translateable_attributes).to eq({})
      end
    end

    it 'raises an error if called with a locale that is not available for this record yet' do
      expect { dummy_instance.translateable_attributes(:es) }.to raise_error(ArgumentError)
    end
  end

  describe '#target_translation_locales' do
    context 'when the record is created' do
      it 'returns an array of all supported locales, minus the current one' do
        expect(dummy_instance.target_translation_locales).to eq(I18n.available_locales - [:en])
        I18n.with_locale(:es) { dummy_instance.update!(title: 'Título', description: 'Descripción') }
        expect(dummy_instance.target_translation_locales).to eq(I18n.available_locales - %i[en es])
      end
    end
  end

  describe '#auto_translate' do
    it 'calls AITools::AutoTranslator with translateable_attributes' do
      translateable_attributes = { title: dummy_instance.title, description: dummy_instance.description }
      expect(dummy_instance).to receive(:translateable_attributes).and_return(translateable_attributes)
      expect(dummy_instance).to receive(:target_translation_locales).and_return(I18n.available_locales - [:en])
      expect(AITools::AutoTranslator).to receive(:call).with(
        translateable_attributes, target_locales: I18n.available_locales - [:en],
                                  source_locale: :en
      ).and_return('de' => { 'title' => 'Titel', 'description' => 'Beschreibung' },
                   'es' => { 'title' => 'Título', 'description' => 'Descripción' })

      dummy_instance.auto_translate
      dummy_instance.reload
      I18n.with_locale(:de) do
        expect(dummy_instance.title).to eq('Titel')
        expect(dummy_instance.description).to eq('Beschreibung')
      end
      I18n.with_locale(:es) do
        expect(dummy_instance.title).to eq('Título')
        expect(dummy_instance.description).to eq('Descripción')
      end
    end

    it 'doesn\'t call AITools::AutoTranslator if there are no translateable attributes' do
      I18n.with_locale(:es) do
        # allow(dummy_instance).to receive(:translateable_attributes).and_return({})
        expect(AITools::AutoTranslator).not_to receive(:call)
        dummy_instance.auto_translate
      end
    end

    it 'doesn\'t call AITools::AutoTranslator if there are no target locales' do
      expect(dummy_instance).to receive(:translateable_attributes).and_return(title: 'Title',
                                                                              description: 'Description')
      expect(dummy_instance).to receive(:target_translation_locales).and_return([])

      expect(AITools::AutoTranslator).not_to receive(:call)

      dummy_instance.auto_translate
    end
  end

  describe '#auto_translate_later' do
    it 'enqueues a background job to call auto_translate' do
      expect(AutoTranslateJob).to receive(:perform_later).with(dummy_instance.id, dummy_instance.model_name.to_s, 'en')

      dummy_instance.auto_translate_later
    end
  end
end
