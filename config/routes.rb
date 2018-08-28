Flexite::Engine.routes.draw do
  resources :entries do
    collection do
      get 'new_array' => 'entries#new_array_entry'
      delete 'destroy_array' => 'entries#destroy_array_entry'
      get ':parent_id/select_type' => 'entries#select_type', as: :select_type
    end
  end

  resources :configs do
    resources :entries
    resources :configs, only: [:index, :new]
    get :reload, on: :collection
  end

  resources :histories, only: [] do
    get ':entity_id/:entity_type/show', to: 'histories#index', as: :entity, constraints: { entity_type: /.*/ }, on: :collection
    get :restore
  end

  resource :diff, only: [:show] do
    post :check
    post :apply
    post :save_diff
    get :push
  end

  namespace :api, defaults: { format: :json } do
    get :configs
  end

  root to: 'application#index'
end
