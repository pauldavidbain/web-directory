class PersonPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def show?
    permitted_to_see_affiliations? || user.try(:admin?) || user.try(:developer?)
  end

  def can_see_employee_phone?
    UserPermissables.new(user).phones.include?(:employee_phone)
  end

  def can_see_alternate_phone?
    UserPermissables.new(user).phones.include?(:alternate_employee_phone)
  end

  private

  def permitted_to_see_affiliations?
    (record.visible_affiliations & UserPermissables.new(user).affiliations).any?
  end

end
