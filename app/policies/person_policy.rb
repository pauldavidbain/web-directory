class PersonPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      if user.nil?
        scope.not_confidential.any_in(affiliations: [ 'trustee', 'faculty' ])
      elsif user.admin? || user.developer?
        scope.all
      elsif user.employee? || user.faculty?
        scope.not_confidential.any_in(affiliations: [ 'employee', 'student', 'trustee', 'faculty', 'alumnus' ])
      elsif user.student?
        scope.not_confidential.any_in(affiliations: [ 'employee', 'student', 'trustee', 'faculty' ])
      elsif user.alumnus?
        scope.not_confidential.any_in(affiliations: [ 'trustee', 'faculty', 'alumnus' ])
      else
        scope.not_confidential.any_in(affiliations: [ 'trustee', 'faculty' ])
      end
    end
  end

end