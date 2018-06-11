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
    resources :configs, only: :index
    get :reload, on: :collection
  end

  root to: 'application#index'
end
