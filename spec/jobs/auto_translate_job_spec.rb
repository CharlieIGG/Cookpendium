require 'rails_helper'

RSpec.describe AutoTranslateJob, type: :job do
  describe '#perform' do
    let!(:dummy_instance) { AutoTranslateableDummyModel.create(title: 'Title', description: 'Description') }

    it 'calls #auto_translate on the model' do
      allow(dummy_instance).to receive(:auto_translate)
      expect(AutoTranslateableDummyModel).to receive(:find).with(dummy_instance.id).and_return(dummy_instance)
      expect(dummy_instance).to receive(:auto_translate)

      AutoTranslateJob.perform_now(dummy_instance.id, 'AutoTranslateableDummyModel')
    end
  end
end
