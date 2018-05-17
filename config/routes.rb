Flexite::Engine.routes.draw do
  resources :entries do
    post 'new/value', to: 'entries#value', on: :collection
  end

  resources :bool_entries, controller: :entries
  resources :int_entries, controller: :entries
  resources :str_entries, controller: :entries
  resources :sym_entries, controller: :entries
  resources :arr_entries, controller: :entries
  resources :configs do
    get '/:parent_id/entries', on: :collection, to: 'configs#entries', as: :entries
  end

  resources :sections do
    resources :configs do
      resources :entries do
        post 'new/value', to: 'entries#value', on: :collection
      end

      resources :bool_entries, controller: :entries
      resources :int_entries, controller: :entries
      resources :str_entries, controller: :entries
      resources :sym_entries, controller: :entries
      resources :arr_entries, controller: :entries
    end
  end

  root to: 'sections#index'
end
