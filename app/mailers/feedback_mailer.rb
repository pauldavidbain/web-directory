class FeedbackMailer < ActionMailer::Base
  default from: Settings.email.from

  def new_feedback(options)
    @feedback = options[:feedback]
    @name = options[:name]
    @email = options[:email]
    @url = options[:request_url]

    if @feedback.present?
      from_string = @name.present? ? "from #{@name} " : ""
      mail(to: Settings.feedback.mail_to, reply_to: @email.presence, subject: "Directory Feedback #{from_string}##{random_id}")
    end
  end

  private

  # Add to subject line to prevent different emails from getting grouped together into the same thread.
  def random_id
    # Since it is just to generate a unique ID, the actual date doesn't matter (which is why I subtract a time in the past)
    # 1295 == 36^2 - 1. Keeps it to 2 digits.
    (Time.now.to_i - 1417740000).to_s(36) + rand(1295).to_s(36)
  end
end
