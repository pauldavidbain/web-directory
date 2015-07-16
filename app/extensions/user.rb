User.class_eval do
  [:admin, :developer, :faculty, :student, :employee, :alumnus, :trustee, :volunteer].each do |affl|
    define_method "#{affl}?" do
      has_role? affl
    end
  end

  def student_worker?
    # Student worker has a space in it so it needs some special attention
    has_role?(:"student worker") || has_role?(:student_worker)
  end

  # This actually looks up the person by their biola_id number
  def find_person
    @user_person ||= Person.where(biola_id: biola_id).first
  end
end
