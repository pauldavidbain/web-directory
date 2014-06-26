BiolaFrontendToolkit.configure do |config|
  config.app_name = Settings.app.name
  # config.app_version = Version.current  # Don't set this right now
  config.release_phase = Settings.release.phase
  config.relative_root = Settings.app.relative_url_root
  config.app_links = [
    {title: Settings.app.name, url: Settings.app.relative_url_root, icon: 'home'},
    {title: 'Gmail', url: 'http://mail.biola.edu', icon: 'envelope-square'},
    {title: 'Forms', url: 'http://forms.biola.edu', icon: 'check-square-o'},
  ]
  config.profile_links = [
    {title: 'My Profile', url: '#', icon: 'user'},
  ]

  config.ga_account = Settings.google_analytics.account
  config.ga_domain = Settings.google_analytics.domain
  config.ga_enabled = Settings.google_analytics.enabled
end
