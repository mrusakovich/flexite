Flexite::Engine.routes.draw do
  resources :entries do
    collection do
      get 'new_array' => 'entries#new_array_entry'
      delete 'destroy_array' => 'entries#destroy_array_entry'
      get ':parent_id/select_type' => 'entries#select_type', as: :select_type
    end
  end

  resources :sections
  resources :configs do
    resources :entries
  end

  resources :parents do
    get :select, as: :select, on: :collection
    get ':parent_type/configs' => 'parents#configs', constraints: { parent_type: /.*/ }, as: :configs
  end

  root to: 'sections#index'
end
