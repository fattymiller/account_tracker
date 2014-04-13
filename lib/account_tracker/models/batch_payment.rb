module AccountTracker
  class BatchPayment < ActiveRecord::Base
    belongs_to :account, class_name: "AccountTracker::Account", touch: true
    belongs_to :transaction, class_name: "AccountTracker::Transaction"
    
    has_many :allocated_payments, class_name: "AccountTracker::InvoicePayment"
    
    after_touch :update_cached_values
    
    def allocate!(invoice, amount_in_cents)
      raise "Please specify an invoice to allocate this payment to." unless invoice
      raise "Please specify an amount to allocate to this invoice" unless amount_in_cents
      
      raise "Unable to allocate #{amount_in_cents} cents to this invoice. Amount must be a non-negative number" if amount_in_cents <= 0
      raise "Unable to allocate #{amount_in_cents} cents. Current balance remaining is only #{remaining} cents." if amount_in_cents > remaining
      
      invoice.payments.create!({ amount_in_cents: amount_in_cents, batch_payment_id: self.id })
    end
    
    def remaining
      amount_in_cents - allocated_amount_in_cents
    end
    
    private
    
    def update_cached_values
      update_attributes({ allocated_amount_in_cents: allocated_payments.sum(:amount_in_cents) })
    end
  end
end