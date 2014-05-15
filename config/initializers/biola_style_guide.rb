BiolaStyleGuide.configure do |config|
  config.app_name = Settings.app.name
  # config.app_version = Version.current  # Don't set this right now
  config.relative_root = Settings.app.relative_url_root
end