class PersonPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def show?
    permitted_to_see_affiliations? || record.is_public? || user.try(:admin?) || user.try(:developer?)
  end

  def edit?
    user && ((user.biola_id == record.biola_id) || record.actors.include?(user) || super)
  end

  def can_see_assistants?
    user && user.employee?
  end

  def can_see_biola_email?
    user.present?
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
