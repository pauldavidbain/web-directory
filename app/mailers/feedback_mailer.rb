class FeedbackMailer < ActionMailer::Base
  default from: 'no-reply@biola.edu'

  def new_feedback(options)
    @feedback = options[:feedback]
    @name = options[:name]
    @email = options[:email]
    @url = options[:request_url]

    if @feedback.present?
      mail(to: Settings.feedback.mail_to, reply_to: @email.presence, subject: "Directory Feedback ##{random_id}")
    end
  end

  private

  # Add to subject line to prevent different emails from getting grouped together into the same thread.
  def random_id
    Time.now.to_i.to_s(36) + rand(100000000).to_s(36)
  end
end
