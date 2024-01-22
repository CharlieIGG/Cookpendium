# frozen_string_literal: true

module Api
  module V1
    class IngredientsController < ApplicationController
      def create
        @ingredient = Ingredient.new(ingredient_params)
        if @ingredient.save
          render json: @ingredient, status: :created
        else
          errors = @ingredient.errors.full_messages.prepend(I18n.t('helpers.errors.create',
                                                                   model: Ingredient.model_name.human)).to_json
          render json: errors, status: :unprocessable_entity
        end
      end

      private

      def ingredient_params
        params.require(:ingredient).permit(:name)
      end
    end
  end
end
