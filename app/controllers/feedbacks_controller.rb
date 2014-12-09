require 'net/http'

class FeedbacksController < ApplicationController
  skip_after_action :verify_authorized, :verify_policy_scoped

  def create
    not_robot = true

    # Verify CAPTCHA if the user is not logged in and captcha is configured.
    unless current_user || Settings.recaptcha.try(:secret).blank?
      uri = URI.parse(Settings.recaptcha.base_url)
      gparams = {
        secret: Settings.recaptcha.secret,
        response: params['g-recaptcha-response']
      }
      uri.query = URI.encode_www_form(gparams)
      res = Net::HTTP.get_response(uri)
      not_robot = JSON.parse(res.body)["success"]
    end

    # Send feedback if user is not a robot.
    if not_robot
      options = params.permit(:feedback, :name, :email)
      options[:request_url] = request.referer
      FeedbackMailer.new_feedback(options).deliver if options[:feedback].present?
      redirect_to thanks_feedbacks_path
    else
      redirect_to robot_feedbacks_path
    end
  end

  def thanks
  end

  def robot
  end
end
