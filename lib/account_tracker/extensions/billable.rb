module AccountTracker
  module Billable
    extend ActiveSupport::Concern

    included do
      extend ClassMethods
      
      class_attribute :invoiceable_to
      class_attribute :invoiceable_at
      class_attribute :invoiceable_as

      class_attribute :tax_rate
      class_attribute :tax_included

      class_attribute :invoiceable_quantity
      
      has_many :invoice_line_items, class_name: "AccountTracker::InvoiceLineItem", as: :billable_item
      has_many :invoices, class_name: "AccountTracker::Invoice", through: :invoice_line_items
      
      after_create :create_invoice_item
      
      def invoiceable_to
        try_get_class_value(self.class.invoiceable_to)
      end
      def invoiceable_at
        try_get_class_value(self.class.invoiceable_at)
      end
      def invoiceable_as
        try_get_class_value([self.class.invoiceable_as, :format, :name]) || "#{self.class.name}##{self.id}"
      end

      def tax_rate
        try_get_class_value(self.class.tax_rate)
      end
      def tax_included
        try_get_class_value(self.class.tax_included)
      end

      def invoiceable_quantity
        try_get_class_value(self.class.invoiceable_quantity) || 1
      end
      
      def paid_in_full?
        invoice_line_items.all? { |line_item| line_item.paid_in_full? }
      end
      def outstanding?
        !paid_in_full?
      end
      
      def line_items
        persisted? ? invoice_line_items : [mock_invoice_item]
      end
      
      private
      
      def prepare_billable_invoice_lines
        price_in_cents = invoiceable_at
        raise "[#{self.class.name}] price_in_cents can not be nil." unless price_in_cents
        
        attributes = { 
          billable_item: self, 
          quantity: invoiceable_quantity, 
          price_in_cents: price_in_cents }
          
        attributes[:tax_rate] = tax_rate if tax_rate
        attributes[:tax_included_in_price] = tax_included if tax_included
        
        attributes
      end
      
      def mock_invoice_item
        AccountTracker::InvoiceLineItem.new(prepare_billable_invoice_lines)
      end
      def create_invoice_item
        target = invoiceable_to
        raise "[#{self.class.name}] invoiceable_to can not be nil." unless target
        
        target.detached_billables.create!(prepare_billable_invoice_lines)
      end
      
      def try_get_class_value(field_value)
        return nil unless field_value
        
        field_value = [field_value] unless field_value.is_a?(Array)
        
        field_value.each do |value|
          result = nil
          
          if value.is_a?(Symbol)
            if self.respond_to?(value)
              result = self.send(value)
            end
          else
            result = value
          end
          
          return result if result
        end
        
        nil
      end
    end
    
    module ClassMethods      
      def invoiceable(options = {})
        self.invoiceable_to = options.delete(:to)
        self.invoiceable_at = options.delete(:at)        
        raise "[#{self.name}] at a minimum, `invoiceable` requires both :to (owning entity) and :at (price in cents) to be non-null." unless self.invoiceable_to && self.invoiceable_at

        self.invoiceable_as = options.delete(:as)

        self.tax_rate = options.delete(:tax_rate)
        self.tax_included = options.delete(:tax_included)

        self.invoiceable_quantity = options.delete(:default_quantity)
      end
    end

  end
end