module AccountTracker
  class AccountsController < ApplicationController
    load_and_authorize_resource
    
    # def model_name
    #   AccountTracker::Account.name
    # end

    # private

    # def admin_params
    #   params[:admin]
    # end
  end
end