Directory::Application.routes.draw do

  get '/search', to: 'searches#search'
  root to: 'searches#landing'

  # this is just a convenience to create a named route to rack-cas' logout
  get '/logout' => -> env { [200, { 'Content-Type' => 'text/html' }, ['Rack::CAS should have caught this']] }, as: :logout

end
