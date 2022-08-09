# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'urls#index'

  resources :urls, only: %i[index create show], param: :url
  get '/url_list', to: 'urls#url_list'
  get ':short_url', to: 'urls#visit', as: :visit
  post '/create_click', to: 'urls#create_click'
end
