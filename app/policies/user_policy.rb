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

  def use_ai?
    return false unless user.present?
    return true if user.admin?

    user.ai_usage_this_week < MAX_AI_USAGE_PER_USER_PER_WEEK
  end
end
