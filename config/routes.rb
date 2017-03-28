Rails.application.routes.draw do
  mount ActionCable.server => :cable
  get :live, to: 'live#show'
  get 'images/:id', to: 'images#show'
  get 'images', to: 'images#index'
end
