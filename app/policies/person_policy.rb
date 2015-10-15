class PersonPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def show?
    if user
      permitted_to_see_affiliations? || user.admin?
    else
      (record.is_public? && permitted_to_see_affiliations?)
    end
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

  def can_see_student_mailbox?
    user.present?
  end

  def can_see_degree?
    user.present?
  end

  def can_see_employee_phone?
    UserPermissables.new(user).phones.include?(:employee_phone)
  end

  def can_see_alternate_phone?
    UserPermissables.new(user).phones.include?(:alternate_employee_phone)
  end

  def can_see_biola_id?
    user && user.employee? && record.employee?
  end

  private

  def permitted_to_see_affiliations?
    (record.visible_affiliations & UserPermissables.new(user).affiliations).any?
  end

end
