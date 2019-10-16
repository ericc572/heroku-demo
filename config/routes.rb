require "sidekiq/web"
Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'welcome#index'
  scope '/hooks', :controller => :hooks do
    post :survey_created
    post :sms_received
  end

  mount Sidekiq::Web => '/sidekiq'
end
