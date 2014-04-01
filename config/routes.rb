Directory::Application.routes.draw do

  resources :people, only: [] do
    member do
      get :staff
    end
  end

  get '/search', to: 'searches#search'
  root to: 'searches#landing'

  # this is just a convenience to create a named route to rack-cas' logout
  get '/logout' => -> env { [200, { 'Content-Type' => 'text/html' }, ['Rack::CAS should have caught this']] }, as: :logout

end
