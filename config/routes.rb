Directory::Application.routes.draw do

  resources :feedbacks, path: 'feedback', only: :create do
    get :thanks, on: :collection
  end
  resources :faculty, only: [:index]
  resources :people, only: [:show]
  resources :departments, path: 'offices-services', only: [:show]
  resources :groups, only: [:show]

  get "/search", to: "searches#search"
  get "/people" => redirect { |params, request| "#{ Rails.application.config.action_controller.relative_url_root }/search?#{request.params.merge({_type: 'person'}).to_query}" }
  get "/departments" => redirect { |params, request| "#{ Rails.application.config.action_controller.relative_url_root }/search?#{request.params.merge({_type: 'department'}).to_query}" }
  get "/offices-services" => redirect { |params, request| "#{ Rails.application.config.action_controller.relative_url_root }/search?#{request.params.merge({_type: 'department'}).to_query}" }
  get "/groups" => redirect { |params, request| "#{ Rails.application.config.action_controller.relative_url_root }/search?#{request.params.merge({_type: 'group'}).to_query}" }


  root to: 'searches#landing'

  # this is just a convenience to create a named route to rack-cas' logout
  get '/logout' => -> env { [200, { 'Content-Type' => 'text/html' }, ['Rack::CAS should have caught this']] }, as: :logout

  # catch all so we can handle routing errors our own way.
  get "*path", to: "application#routing_error", via: :all
end
