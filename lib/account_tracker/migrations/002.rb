module AccountTracker
  module Migrations
    module ExtendInvoiceInformation
      def self.included(klass)
        klass.class_eval do
          register_migrations_for [0,0,2] do |m|
            m.add_column :account_tracker_invoice_payments, :batch_payment_id, :integer
            
            m.add_column :account_tracker_invoice_payments, :amount_in_cents, :integer
            m.change_column :account_tracker_invoice_payments, :amount_in_cents, :integer, null: false            
            
            m.add_column :account_tracker_batch_payments, :amount_in_cents, :integer
            m.change_column :account_tracker_batch_payments, :amount_in_cents, :integer, null: false
            
            m.add_column :account_tracker_batch_payments, :allocated_amount_in_cents, :integer, null: false, default: 0
          end
        end
      end
    end
  end
end