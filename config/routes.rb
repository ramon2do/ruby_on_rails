Rails.application.routes.draw do
  # get 'contact/index'

  # get 'site/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root path
  root "site#login"

  # index path
  # get "index" => "contact#index"
  
  # login path
  get "login" => "site#login"
  post "signin" => "site#signin"

  # register path
  post "signup" => "site#signup"

  # logout path
  get "logout" => "site#logout"

  # contact path
  get "contacts" => "contact#index"
  get "contact" => "contact#create"
  get "contact/:id" => "contact#update"

  post "addcontact" => "contact#add"
  post "updatecontact" => "contact#change"
  post "delete/:id" => "contact#delete"

end
