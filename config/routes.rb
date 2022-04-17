Rails.application.routes.draw do

  resources :home
  root 'home#top' #トップページをhomeコントローラのtopアクションに設定

  get '' => "home#top"

  get 'manga/top'
  get 'manga/index'
  get "manga/give"
  get "manga/togive"
  get "manga/toget"
  get "manga/deal" => "manga#deal"
  get "manga/notyet" => "manga#notyet"

  post "manga/pay" => "manga#pay"
  post "manga/create_pay" => "manga#create_pay"
  post "manga/card_pay/:customer_id" => "manga#card_pay"
  post "manga/fakepay" => "manga#fakepay"
  post "manga/offer" => "manga#offer"

  get "manga/register"
  post "manga/insert" => "manga#insert"

  get "manga/:id" => "manga#page"

  post "complete/:id" => "manga#complete"

  get "user/give"
  get "user/pay"
  get "user/set" =>"user#set"
  get "user/ad_setting"
  get "register" => "user#register"
  post "user/create" => "user#create"
  post "user/name" => "user#name"
  get "login" => "user#login"
  post "user/login_form" =>"user#login_form"
  get "user/:id" => "user#page"
  post "user/address" => "user#address"
  post "logout" => "user#logout"


  resources :card
  post "card/create" => "card#create"

  #
  # resources :card, only: [:new, :show] do
  #   collection do
  #     post 'show', to: 'card#show'
  #     post 'pay', to: 'card#pay'
  #     post 'delete', to: 'card#delete'
  #   end
  # end

  # get "card/new" => "card#new"
  # get "card/show" => "card#show"
  # get "card/pay" => "card#pay"
  # post "card/delete" =>"card#delete"


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
