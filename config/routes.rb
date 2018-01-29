Rails.application.routes.draw do
  get '/', to: redirect('/signup')

  get '/signup', to: 'membership#new', as: 'signup'
  post '/signup', to: 'membership#create', as: 'subscribe'

  get '/manage/:uuid', to: 'membership#manage'
  patch '/update', to: 'membership#update', as: 'update'

  get '/confirm/:uuid/:code', to: 'membership#confirm_email'
  get '/member/resend_confirmation/:uuid', to: 'membership#resend_confirmation_email'

  get '/delete/:uuid', to: 'membership#delete'
  post '/destroy', to: 'membership#destroy'
  get '/deleted', to: 'membership#deleted'

  get    '/events',              to: 'event#index',    as: 'events'
  get    '/events/new',          to: 'event#new',      as: 'new_event'
  post   '/events',              to: 'event#create',   as: 'create_event'
  get    '/events/:uuid',        to: 'event#show',     as: 'event'
  get    '/event/:uuid/edit',    to: 'event#edit',     as: 'edit_event'
  patch  '/events/:uuid',        to: 'event#update',   as: 'update_event'
  get    '/events/:uuid/delete', to: 'events#destroy', as: 'delete_event'
  delete '/events/:uuid',        to: 'events#destroy', as: 'destroy_event'

  post '/event/synidicate/:uuid', to: 'event#syndicate'

  get '/event/delete/:uuid', to: 'event#delete'
  post '/event/destroy', to: 'event#destroy'
end
