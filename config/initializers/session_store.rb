require 'rack-cas/session_store/rails/mongoid'
Directory::Application.config.session_store :rack_cas_mongoid_store, key: '_web_directory_session'
