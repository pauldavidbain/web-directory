module WhatAUserCanSee
  extend ActiveSupport::Concern

  def can_see_phone?
    has_role? :employee, :faculty, :student_worker, :trustee
  end

end
