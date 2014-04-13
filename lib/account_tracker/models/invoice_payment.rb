module AccountTracker
  class InvoicePayment < ActiveRecord::Base
    belongs_to :invoice, class_name: "AccountTracker::Invoice", foreign_key: "account_tracker_invoice_id", touch: true
    belongs_to :transaction, class_name: "AccountTracker::Transaction"    

    belongs_to :batch_payment, class_name: "AccountTracker::BatchPayment", touch: true    
  end
end