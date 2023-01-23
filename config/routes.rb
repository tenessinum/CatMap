Rails.application.routes.draw do
  get 'compass/find'
  post 'point/create'
  post 'point/edit'
  delete 'point/remove'
  post 'point/extract'
  devise_for :users
  get 'map/view'
  root "map#view"
end
