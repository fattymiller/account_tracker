module AccountTracker
  class Account < ActiveRecord::Base
    belongs_to :owning_entity, polymorphic: true
    
    has_many :batch_payments, class_name: "AccountTracker::BatchPayment"
    
    has_many :invoices, class_name: "AccountTracker::Invoice"
    has_many :invoice_payments, class_name: "AccountTracker::InvoicePayment", through: :invoices
    
    scope :overdue, -> { where("overdue_in_cents > 0") }
    scope :outstanding, -> { where("outstanding_in_cents > 0") }
    
    after_touch :update_cached_values
    
    private
    
    def update_cached_values
      update_attributes({ 
        outstanding_in_cents: invoices.current.sum_outstanding,
        overdue_in_cents: invoices.overdue.sum_outstanding
      })
    end
  end
end