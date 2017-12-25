Rails.application.routes.draw do
  get '/', to: redirect('/signup')

  get '/signup', to: 'membership#new', as: 'signup'
  post '/signup', to: 'membership#create', as: 'subscribe'

  get '/manage/:uuid', to: 'membership#manage'
  patch '/update', to: 'membership#update', as: 'update'

  get '/delete/:uuid', to: 'membership#delete'
  post '/destroy', to: 'membership#destroy'
  get '/deleted', to: 'membership#deleted'
end
