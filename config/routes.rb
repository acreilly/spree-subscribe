Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :subscription_intervals do
      collection do
        get :search
      end
    end
    resources :subscriptions, :except => [:new,:create]
    put "/subscriptions/:id/activate" => "subscriptions#activate", as: :subscription_activate
  end

  resources :subscriptions, :only => [:destroy, :update]



end
