module AccountTracker
  module Migrations
    module InitialDataSetup
      def self.included(klass)
        klass.class_eval do
          register_migrations_for [0,0,1] do |m|
            m.create_table :account_tracker_accounts do |t|
              t.integer :owning_entity_id, null: false
              t.string :owning_entity_type, null: false
              
              t.integer :default_pay_period, null: false, default: 7 # default number of days after an invoice is raised that it needs to be paid by
              
              t.integer :outstanding_in_cents, null: false, default: 0 # the total amount outstanding for this account (cached from invoice associations)              
              t.integer :overdue_in_cents, null: false, default: 0 # the total amount overdue for this account (cached from invoice associations)              
            
              t.timestamps
            end

            m.create_table :account_tracker_batch_payments do |t|
              t.references :account_tracker_account, null: false
              t.references :account_tracker_transaction, null: false 
            
              t.timestamps
            end

            m.create_table :account_tracker_invoice_payments do |t|
              t.references :account_tracker_invoice, null: false
              t.references :account_tracker_transaction, null: false 
            
              t.timestamps
            end

            m.create_table :account_tracker_transactions do |t|
              t.integer :payment_source_id, null: false 
              t.string :payment_source_type, null: false 
              
              t.integer :amount_in_cents, null: false, default: 0
              
              t.boolean :success, null: false
              t.string :authorisation
              t.string :message
              t.text :params
              
              t.integer :payment_transaction_id, null: false # remove me?
            
              t.timestamps
            end

            m.create_table :account_tracker_invoices do |t|
              t.references :account_tracker_account # once this is attached to a confirmed Account

              t.integer :owning_entity_id, null: false # taken from the Billables - used as a backup for when an Account is not attached
              t.string :owning_entity_type, null: false 

              t.integer :amount_in_cents, null: false, default: 0 # the total amount payable for this invoice (cached from record associations)
              t.integer :paid_in_cents, null: false, default: 0 # the total amount payable for this invoice (cached from record associations)
              t.integer :outstanding_in_cents, null: false, default: 0 # the total amount payable for this invoice (cached from record associations)
              
              t.datetime :due_at
              
              t.timestamps
            end

            m.create_table :account_tracker_invoice_line_items do |t|
              t.references :account_tracker_invoice
              
              t.integer :billable_item_id, null: false
              t.string :billable_item_type, null: false
              
              t.integer :quantity, null: false
              t.integer :price_in_cents, null: false
              t.integer :subtotal, null: false # cached value of quantity * price_in_cents
              
              t.decimal :tax_rate, null: false, default: 0
              t.boolean :tax_included_in_price, null: false, default: false
            
              t.timestamps
            end

            m.create_table :account_tracker_invoice_additional_charges do |t|
              t.references :account_tracker_invoice
              t.string :chargeable_type, null: false
              
              t.integer :price_in_cents, null: false
            
              t.timestamps
            end
          end
        end
      end
    end
  end
end