require_relative "version"

require_relative "migrations/001"
require_relative "migrations/002"
require_relative "migrations/003"

module AccountTracker
  class Plugin < BaseJump::Plugins::Base
    include Migrations::InitialDataSetup
    include Migrations::ExtendInvoiceInformation
    include Migrations::DetachableLineItems
    
    register "beda2b06-613e-45b3-904a-93a86f335f50", :version => AccountTracker::VERSION.split(".")
  end
  
  def self.table_name_prefix
    "account_tracker_"
  end
end

require_relative "controllers/routes"
require_relative "controllers/account_tracker/accounts_controller"
require_relative "controllers/account_tracker/invoices_controller"

require_relative "extensions/billable"
require_relative "extensions/invoiceable"

require_relative "models/account"
require_relative "models/batch_payment"
require_relative "models/invoice"
require_relative "models/invoice_additional_charge"
require_relative "models/invoice_line_item"
require_relative "models/invoice_payment"
require_relative "models/transaction"

require_relative "view_models/account_tracker_account_view_model"
require_relative "view_models/account_tracker_invoice_view_model"