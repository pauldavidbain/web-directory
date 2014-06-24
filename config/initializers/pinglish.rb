Directory::Application.config.middleware.use Pinglish do |ping|
  ping.check :mongodb do
    Mongoid.default_session.command(ping: 1).has_key? 'ok'
  end

  ping.check :smtp do
    smtp = Net::SMTP.new(ActionMailer::Base.smtp_settings[:address])
    smtp.start
    ok = smtp.started?
    smtp.finish

    ok
  end

  ping.check :elasticsearch do
    Elasticsearch::Model.client.indices.exists index: Settings.elasticsearch.index_name
  end
end
