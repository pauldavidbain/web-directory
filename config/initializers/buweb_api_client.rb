BUWebAPIClient.configure do |config|
  config.scheme = Settings.biola_web_api.scheme
  config.host = Settings.biola_web_api.host
  config.script_name = Settings.biola_web_api.script_name
  config.version = Settings.biola_web_api.version
  config.access_id = Settings.biola_web_api.access_id
  config.secret_key = Settings.biola_web_api.secret_key
end