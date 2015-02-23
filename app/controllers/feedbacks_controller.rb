class FeedbacksController < ApplicationController
  skip_after_action :verify_authorized, :verify_policy_scoped

  def create
    if user_logged_in?
      options = params.permit(:feedback, :name, :email)
      options[:request_url] = request.referer
      FeedbackMailer.new_feedback(options).deliver if options[:feedback].present?
    end

    redirect_to thanks_feedbacks_path
  end

  def thanks
  end
end
