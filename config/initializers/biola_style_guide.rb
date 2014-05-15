BiolaStyleGuide.configure do |config|
  config.app_name = Settings.app.name
  # config.app_version = Version.current  # Don't set this right now
  config.relative_root = Settings.app.relative_url_root
  config.app_links = [
    {title: Settings.app.name, url: Settings.app.relative_url_root, icon: 'home'},
    {title: 'Gmail', url: 'http://mail.biola.edu', icon: 'envelope-square'},
    {title: 'Forms', url: 'http://forms.biola.edu', icon: 'check-square-o'},
  ]
end