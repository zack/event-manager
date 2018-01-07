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
end
