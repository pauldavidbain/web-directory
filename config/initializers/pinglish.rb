Directory::Application.config.middleware.use Pinglish do |ping|
  ping.check :db do
    ActiveRecord::Base.connected?
  end

  ping.check :smtp do
    smtp = Net::SMTP.new(ActionMailer::Base.smtp_settings[:address])
    smtp.start
    ok = smtp.started?
    smtp.finish

    ok
  end
end