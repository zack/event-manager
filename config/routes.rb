Rails.application.routes.draw do
  get '/', to: 'welcome#index', as: 'index'

  get    '/users/new',                        to: 'users#new',                    as: 'new_user'
  post   '/users',                            to: 'users#create',                 as: 'create_user'
  get    '/users/:uuid',                      to: 'users#edit',                   as: 'edit_user'
  patch  '/users/:uuid',                      to: 'users#update',                 as: 'update_user'
  get    '/users/:uuid/delete',               to: 'users#delete',                 as: 'delete_user'
  delete '/users/:uuid',                      to: 'users#destroy',                as: 'destroy_user'
  get    '/users/deleted',                    to: 'users#deleted',                as: 'deleted_user'
  get    '/users/confirm_email/:code',        to: 'users#confirm_email',          as: 'confirm_email'
  get    '/users/revert_email/:code',         to: 'users#revert_email',           as: 'revert_email'
  get    '/users/:uuid/resend_confirmation',  to: 'users#resend_confirmation',    as: 'reconfirm_user_confirmation'
  get    '/users/recover_account',            to: 'users#recover_account',        as: 'recover_account'
  post   '/users/recover_account',            to: 'users#recover_account_submit', as: 'recover_account_submit'

  get    '/events',                  to: 'events#index',     as: 'events'
  get    '/events/new',              to: 'events#new',       as: 'new_event'
  post   '/events',                  to: 'events#create',    as: 'create_event'
  get    '/events/:uuid',            to: 'events#show',      as: 'event'
  get    '/events/:uuid/edit',       to: 'events#edit',      as: 'edit_event'
  patch  '/events/:uuid',            to: 'events#update',    as: 'update_event'
  get    '/events/:uuid/delete',     to: 'events#delete',    as: 'delete_event'
  delete '/events/:uuid',            to: 'events#destroy',   as: 'destroy_event'
  post   '/events/:uuid/synidicate', to: 'events#syndicate', as: 'syndicate_event'

  get    '/errors/email_already_confirmed', to: 'errors#email_already_confirmed', as: 'email_already_confirmed'
end
