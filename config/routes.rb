Rails.application.routes.draw do
  mount ActionCable.server => :cable
  get :live, to: 'live#show'
  get 'images/:id', to: 'images#show', format: 'png'
end
