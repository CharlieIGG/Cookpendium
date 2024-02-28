class RecipePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    user.present? && (user.author?(record) || user.admin?)
  end

  def destroy?
    user.present? && (user.author?(record) || user.admin?)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
