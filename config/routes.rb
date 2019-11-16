Rails.application.routes.draw do
  get    '/',                                to: 'welcome#index',                      as: 'root'

  get    '/admin',                           to: 'admin#index',                    as: 'admin_index'
  get    '/admin/email',                     to: 'admin#compose_email',            as: 'admin_compose_email'
  post   '/admin/email',                     to: 'admin#send_email',               as: 'admin_send_email'
  get    '/admin/login',                     to: 'admin#login',                    as: 'admin_login'
  post   '/admin/login',                     to: 'admin#process_login',            as: 'admin_process_login'
  get    '/admin/logout',                    to: 'admin#logout',                   as: 'admin_logout'

  get    '/signup',                          to: 'users#new',                      as: 'signup'
  get    '/users',                           to: 'users#index',                    as: 'users'
  post   '/user',                            to: 'users#create',                   as: 'create_user'
  get    '/user/confirm_email',              to: 'users#confirm_email',            as: 'confirm_email'
  get    '/user/deleted',                    to: 'users#deleted',                  as: 'deleted_user'
  get    '/user/new',                        to: 'users#new',                      as: 'new_user'
  get    '/user/recover_account',            to: 'users#recover_account',          as: 'recover_account'
  post   '/user/recover_account',            to: 'users#recover_account_submit',   as: 'recover_account_submit'
  get    '/user/revert_email/:code',         to: 'users#revert_email',             as: 'revert_email'
  get    '/user/:uuid',                      to: 'users#show',                     as: 'user'
  get    '/user/:uuid/admin',                to: 'users#admin',                    as: 'admin_user'
  get    '/user/:uuid/confirm',              to: 'users#confirm_user',             as: 'confirm_user'
  patch  '/user/:uuid',                      to: 'users#update',                   as: 'update_user'
  get    '/user/:uuid/delete',               to: 'users#delete',                   as: 'delete_user'
  get    '/user/:uuid/delete/admin',         to: 'users#admin_delete',             as: 'admin_delete_user'
  get    '/user/:uuid/resend_confirmation',  to: 'users#resend_confirmation',      as: 'reconfirm_user_confirmation'

  get    '/events',                          to: 'events#index',                   as: 'events'
  post   '/event',                           to: 'events#create',                  as: 'create_event'
  get    '/event/clone',                     to: 'events#clone',                   as: 'clone_event'
  get    '/event/new',                       to: 'events#new',                     as: 'new_event'
  get    '/event/:uuid',                     to: 'events#show',                    as: 'event'
  get    '/event/:uuid/rsvp/:user_uuid',     to: 'events#rsvp',                    as: 'event_rsvp'
  post   '/event/:uuid/rsvp',                to: 'events#submit_rsvp',             as: 'submit_event_rsvp'
  get    '/event/:uuid/admin',               to: 'events#admin',                   as: 'admin_event'
  get    '/event/:uuid/edit',                to: 'events#edit',                    as: 'edit_event'
  patch  '/event/:uuid',                     to: 'events#update',                  as: 'update_event'
  get    '/event/:uuid/delete',              to: 'events#delete',                  as: 'delete_event'
  delete '/event/:uuid',                     to: 'events#soft_delete',             as: 'soft_delete_event'
  get    '/event/:uuid/synidicate',          to: 'events#syndicate',               as: 'syndicate_event'
  get    '/event/:uuid/synidicate_preview',  to: 'events#syndicate_preview',       as: 'syndicate_event_preview'

  get    '/lists',                           to: 'subscription_lists#index',       as: 'lists'
  get    '/list/:id/edit',                   to: 'subscription_lists#edit',        as: 'list'
  post   '/list/update',                     to: 'subscription_lists#update',      as: 'update_list'
  delete '/lists',                           to: 'subscription_lists#delete',      as: 'delete_list'

  get    '/errors/email_already_confirmed',   to: 'errors#email_already_confirmed', as: 'email_already_confirmed'
end
