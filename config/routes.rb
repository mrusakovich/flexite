Flexite::Engine.routes.draw do
  resources :entries
  resources :sections do
    resources :configs do
      resources :entries
    end
  end

  root to: 'sections#index'
end
