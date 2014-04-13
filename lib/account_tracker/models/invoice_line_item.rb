module AccountTracker
  class InvoiceLineItem < ActiveRecord::Base
    belongs_to :invoice, class_name: "AccountTracker::Invoice", foreign_key: "account_tracker_invoice_id", touch: true
    belongs_to :billable_item, polymorphic: true
    belongs_to :invoiceable, polymorphic: true
    
    before_save :update_cache_values
    
    scope :detached, -> { where({ account_tracker_invoice_id: nil }) }
    
    def line_total_excluding_tax
      from_cents(tax_included_in_price ? raw_subtotal - tax : raw_subtotal)
    end
    def line_total_including_tax
      from_cents(tax_included_in_price ? raw_subtotal : raw_subtotal + tax)
    end
    
    def tax
      taxable? ? from_cents(calculate_tax) : 0
    end
    def taxable?
      tax_rate > 0
    end
    
    def paid_in_full?
      !!account_tracker_invoice_id && invoice.paid_in_full?
    end
    def outstanding?
      !paid_in_full?
    end
    
    private
    
    def from_cents(value)
      value / 100.0
    end
    
    def update_cache_values
      self[:subtotal] = raw_subtotal
    end
    
    def raw_subtotal
      quantity * price_in_cents
    end

    def calculate_tax
      return 0 unless taxable?
      
      subtotal = raw_subtotal
      tax_included_in_price ? (subtotal - (subtotal / (1 + tax_rate))) : (subtotal * tax_rate)
    end
  end
end