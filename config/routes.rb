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
  post "manga/fakepay" => "manga#fakepay"
  post "manga/offer" => "manga#offer"
  get "manga/register"
  post "manga/insert" => "manga#insert"

  get "manga/:id" => "manga#page"

  post "complete/:id" => "manga#complete"

  get "user/give"
  get "user/pay"
  get "user/ad_setting"
  get "register" => "user#register"
  post "user/create" => "user#create"
  get "login" => "user#login"
  post "user/login_form" =>"user#login_form"
  get "user/:id" => "user#page"
  post "user/address" => "user#address"
  post "logout" => "user#logout"

  get "card/new" => "card#new"
  get "card/create" => "card#create"
  get "card/show" => "card#show"
  get "card/pay" => "card#pay"
  post "card/delete" =>"card#delete"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
