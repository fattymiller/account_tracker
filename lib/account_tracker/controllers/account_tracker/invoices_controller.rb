module AccountTracker
  class InvoicesController < ApplicationController
    load_and_authorize_resource except: [:create]
    
    def outstanding_billable
      @billable_type = params[:billable_type].safe_constantize
      @billable_id = params[:billable_id].to_i
      
      @billable = @billable_type.try(:find, @billable_id)
      return redirect_to([main_app, @billable]) unless @billable.outstanding?
      
      # authorize!
      
      @invoice = Invoice.prepare_for_billable(@billable)
      
      render 'new' 
    end
    
    def create
      authorize! :create, Invoice
      
      
    end
  
    # def model_name
    #   AccountTracker::Account.name
    # end

    private

    def invoice_params
      # TODO: Need to save payment type
      params.require(:admin).permit()
    end
  end
end