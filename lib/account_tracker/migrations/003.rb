module AccountTracker
  module Migrations
    module DetachableLineItems
      def self.included(klass)
        klass.class_eval do
          register_migrations_for [0,0,3] do |m|
            m.add_column :account_tracker_invoice_line_items, :invoiceable_id, :integer
            m.add_column :account_tracker_invoice_line_items, :invoiceable_type, :string
            
            m.add_column :account_tracker_invoices, :satisfied_at, :datetime
          end
        end
      end
    end
  end
end