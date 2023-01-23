Rails.application.routes.draw do
  post 'point/create'
  delete 'point/remove'
  post 'point/extract'
  devise_for :users
  get 'map/view'
  root "map#view"
end
