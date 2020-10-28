Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/nekocat/index', to: 'nekocat#index'
  get '/nekocat/request_headers', to: 'nekocat#request_headers'
  get '/nekocat/request_body', to: 'nekocat#request_body'

  get '/nekocat/response_headers', to: 'nekocat#response_headers'
  get '/nekocat/response_body', to: 'nekocat#show_response_body'

  post '/nekocat/webhook', to: 'nekocat#webhook'

  get '/nekocat/sent_request', to: 'nekocat#sent_request'
end
