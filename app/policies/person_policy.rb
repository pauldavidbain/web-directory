class PersonPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def show?
    if user.nil?
      # You need to check user.nil? because if it is nil none of the checks below will work if it isn't caught here first.
      (record.visible_affiliations & [:trustee, :faculty]).present?
    elsif user.admin? || user.developer?
      true
    elsif user.employee? || user.faculty?
      (record.visible_affiliations & [:employee, :student, :alumnus, :trustee, :faculty]).present?
    elsif user.student?
      (record.visible_affiliations & [:employee, :student, :trustee, :faculty]).present?
    elsif user.alumnus?
      (record.visible_affiliations & [:alumnus, :trustee, :faculty]).present?
    else
      (record.visible_affiliations & [:trustee, :faculty]).present?
    end
  end

end
