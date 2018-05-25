Flexite::Engine.routes.draw do
  resources :entries
  resources :sections
  resources :configs do
    resources :entries
  end

  get ':parent_type/:parent_id/configs' => 'configs#index', as: :parent_configs, constraints: { parent_type: /.*/ }
  root to: 'sections#index'
end
