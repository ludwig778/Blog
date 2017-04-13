Rails.application.routes.draw do
    root 'articles#index'
    get 'about', to: 'pages#about'

    resources :articles
    #get 'live_search', to: 'articles#live_search'
    get 'search', to: 'articles#search'
    get 'articles/:id/publish', to: 'articles#publish', as: :publish_article

    get 'signup', to: 'users#new'
    resources :users, except: [:new]

    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'

    resources :categories, except: [:destroy]
end
