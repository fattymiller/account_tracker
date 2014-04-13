module AccountTracker
  class InvoiceAdditionalCharge < ActiveRecord::Base
    belongs_to :invoice, class_name: "AccountTracker::Invoice", foreign_key: "account_tracker_invoice_id"
    
  end
end