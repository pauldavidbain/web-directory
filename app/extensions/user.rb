User.class_eval do
  [:admin, :developer, :faculty, :student, :employee, :alumnus, :student_worker, :trustee, :volunteer].each do |affl|
    define_method "#{affl}?" do
      has_role? affl
    end
  end
end
