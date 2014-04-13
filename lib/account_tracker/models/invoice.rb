module AccountTracker
  class Invoice < ActiveRecord::Base
    belongs_to :account, class_name: "AccountTracker::Account", foreign_key: "account_tracker_account_id", touch: true
    belongs_to :owning_entity, polymorphic: true
    
    has_many :line_items, class_name: "AccountTracker::InvoiceLineItem", foreign_key: "account_tracker_invoice_id"
    has_many :additional_charges, class_name: "AccountTracker::InvoiceAdditionalCharge"
    
    has_many :payments, class_name: "AccountTracker::InvoicePayment"
    
    scope :current, -> { where("due_at IS NULL OR due_at > ?", Time.now) }
    scope :overdue, -> { where("due_at IS NOT NULL AND due_at <= ?", Time.now) }
    
    scope :sum_paid, -> { sum(:paid_in_cents) }
    scope :sum_outstanding, -> { sum(:outstanding_in_cents) }
    scope :sum_total, -> { sum(:amount_in_cents) }
    
    after_touch :update_cache_values
    
    def self.prepare_for_billable(billable)
      owning_entity = billable.invoiceable_to
      
      instance = Invoice.new({
        owning_entity_id: owning_entity.id,
        owning_entity_type: owning_entity.class.name
      })
      
      instance.line_items += billable.line_items
      instance
    end
    
    def paid_in_full?(at = Time.now)
      !!satisfied_at && satisfied_at <= at
    end
    
    def overdue?(at = Time.now)
      !paid_in_full?(at) && !!due_at && at > due_at
    end
    def days_overdue(at = Time.now)
      at = satisfied_at if paid_in_full?(at)
      overdue?(at) ? ((at - due_at) / 1.day) : 0
    end
    
    def on_account?
      !!account_id
    end
    def personal?
      !on_account? && !!owning_entiity_id
    end
    
    def new_account=(new_account_name)
      build_account({ name: new_account_name })
    end
    
    # TODO: Cache these on the InvoiceLineItem
    def total_tax
      line_items.collect(&:tax).inject(&:+)
    end
    def total_excluding_tax
      line_items.collect(&:line_total_excluding_tax).inject(&:+)
    end
    def total_including_tax
      line_items.collect(&:line_total_including_tax).inject(&:+)
    end
    
    private
    
    def update_cache_values
      paid = calculate_paid_in_cents
      total = calculate_amount_in_cents
      outstanding = total - paid
      
      attributes = { 
        paid_in_cents: paid,
        outstanding_in_cents: outstanding,
        amount_in_cents: total
      }
      
      if outstanding > 0
        attributes[:satisfied_at] = nil
      elsif !self[:satisfied_at]
        attributes[:satisfied_at] = Time.now
      end
      
      update_attributes(attributes)
    end
    
    def calculate_paid_in_cents
      payments.sum(:amount_in_cents)
    end
    def calculate_amount_in_cents
      line_items.sum(:subtotal)
    end
  end
end