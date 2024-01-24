# frozen_string_literal: true

module Api
  module V1
    class MeasurementUnitsController < ApplicationController
      def create
        @measurement_unit = MeasurementUnit.new(measurement_unit_params)
        if @measurement_unit.save
          render json: @measurement_unit, status: :created
        else
          errors = @measurement_unit.errors.full_messages.prepend(I18n.t('helpers.errors.create',
                                                                         model: MeasurementUnit.model_name.human)).to_json
          render json: errors, status: :unprocessable_entity
        end
      end

      private

      def measurement_unit_params
        params.require(:measurement_unit).permit(:name)
      end
    end
  end
end
