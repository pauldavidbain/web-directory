class UserPermissables
  attr_reader :user

  # Keep in mind that user could possibly be nil
  def initialize(user)
    @user = user
  end

  def affiliations
    if user.present?
      if user.employee? || user.faculty?
        [:faculty, :employee, :trustee, :volunteer, :alumnus, :student]
      elsif user.trustee? || user.volunteer?
        [:faculty, :employee, :trustee, :volunteer, :alumnus]
      elsif user.student? || user.student_worker?
        [:faculty, :employee, :trustee, :volunteer, :student]
      elsif user.alumnus?
        [:faculty, :employee, :trustee, :volunteer, :alumnus]
      else
        [:faculty, :trustee]
      end
    else
      [:faculty, :trustee]
    end
  end
end
