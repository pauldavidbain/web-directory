class PersonPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user.nil?
        scope.any_in(visible_affiliations: [ 'trustee', 'faculty' ])
      elsif user.admin? || user.developer?
        scope.all
      elsif user.employee? || user.faculty?
        scope.any_in(visible_affiliations: [ 'employee', 'student', 'trustee', 'faculty', 'alumnus' ])
      elsif user.student?
        scope.any_in(visible_affiliations: [ 'employee', 'student', 'trustee', 'faculty' ])
      elsif user.alumnus?
        scope.any_in(visible_affiliations: [ 'trustee', 'faculty', 'alumnus' ])
      else
        scope.any_in(visible_affiliations: [ 'trustee', 'faculty' ])
      end
    end
  end

end
