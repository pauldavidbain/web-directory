class UserPermissables
  attr_reader :user

  # Keep in mind that user could possibly be nil
  def initialize(user)
    @user = user
  end

  def affiliations
    if user.present?
      if user.employee? || user.faculty?
        [:faculty, :employee, :contractor, :trustee, :volunteer, :alumnus, :student, :student_worker]
      elsif user.trustee? || user.volunteer?
        [:faculty, :employee, :contractor, :trustee, :volunteer, :alumnus, :student_worker]
      elsif user.student? || user.student_worker?
        [:faculty, :employee, :contractor, :trustee, :volunteer, :student, :student_worker]
      elsif user.alumnus?
        [:faculty, :employee, :contractor, :trustee, :volunteer, :alumnus]
      else
        [:faculty, :employee, :contractor, :trustee]
      end
    else
      # Still gets limited by 'is_public?' which checks for a bio_edition
      [:faculty, :employee, :contractor, :trustee]
    end
  end

  def phones
    all_phones = [:personal_phone, :full_biola_phone_number, :employee_phone, :alternate_employee_phone]
    if user.present?
      if user.employee? || user.faculty?
        all_phones
      elsif user.trustee? || user.volunteer?
        all_phones
      elsif user.student_worker?
        all_phones
      elsif user.student?
        all_phones - [:full_biola_phone_number, :employee_phone]
      elsif user.alumnus?
        all_phones - [:full_biola_phone_number, :employee_phone]
      else
        all_phones - [:full_biola_phone_number, :employee_phone]
      end
    else
      []
    end
  end
end
