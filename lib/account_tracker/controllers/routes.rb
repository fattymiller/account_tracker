Rails.application.routes.prepend do
  namespace :account_tracker do
    resources :accounts, only: [:index, :show]
    
    resources :invoices, only: [:index, :show, :new, :create]
    get "outstanding/:billable_type/:billable_id" => "invoices#outstanding_billable", as: :outstanding_billable
  end
end