class PersonPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def show?
    permitted_to_see_affiliations? || user.try(:admin?) || user.try(:developer?)
  end


  private

  def permitted_to_see_affiliations?
    (record.visible_affiliations & UserPermissables.new(user).affiliations).any?
  end

end
