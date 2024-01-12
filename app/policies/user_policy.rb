class UserPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.has_role?(:superadmin) || (user.has_role?(:admin) && !record.has_role?(:admin))
  end

  def update?
    user.has_role?(:superadmin) || (user.has_role?(:admin) && !record.has_role?(:admin)) || user == record
  end

  def destroy?
    user.has_role?(:superadmin) || (user.has_role?(:admin) && !record.has_role?(:admin)) || user == record
  end
end
