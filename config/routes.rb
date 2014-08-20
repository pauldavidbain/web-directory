Directory::Application.routes.draw do

  resources :people, only: [:show]
  resources :departments, path: 'offices-services', only: [:show]
  resources :services, only: [:show]
  resources :groups, only: [:show]

  get "/search", to: "searches#search"
  get "/people" => redirect { |params, request| "#{ Rails.application.config.action_controller.relative_url_root }/search?#{request.params.merge({_type: 'person'}).to_query}" }
  get "/departments" => redirect { |params, request| "#{ Rails.application.config.action_controller.relative_url_root }/search?#{request.params.merge({_type: 'department'}).to_query}" }
  get "/offices-services" => redirect { |params, request| "#{ Rails.application.config.action_controller.relative_url_root }/search?#{request.params.merge({_type: 'department'}).to_query}" }
  get "/groups" => redirect { |params, request| "#{ Rails.application.config.action_controller.relative_url_root }/search?#{request.params.merge({_type: 'group'}).to_query}" }
  get "/services" => redirect { |params, request| "#{ Rails.application.config.action_controller.relative_url_root }/search?#{request.params.merge({_type: 'service'}).to_query}" }


  root to: 'searches#landing'

  # this is just a convenience to create a named route to rack-cas' logout
  get '/logout' => -> env { [200, { 'Content-Type' => 'text/html' }, ['Rack::CAS should have caught this']] }, as: :logout

end
