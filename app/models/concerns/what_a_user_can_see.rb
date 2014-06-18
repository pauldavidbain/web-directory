module WhatAUserCanSee
  extend ActiveSupport::Concern

  def can_see_phone?
   (affiliations & ["employee", "faculty", "student_worker", "trustee"]).present?
  end

end
