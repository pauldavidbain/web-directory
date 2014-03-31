if defined? ::ExceptionNotifier
  Directory::Application.config.middleware.use ExceptionNotification::Rack,
    email: {
      email_prefix: '[directory] ',
      sender_address: Settings.email.from,
      exception_recipients: Settings.exceptions.mail_to
    }
end