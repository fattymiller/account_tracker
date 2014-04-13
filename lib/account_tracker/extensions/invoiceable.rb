module AccountTracker
  module Invoiceable
    extend ActiveSupport::Concern

    included do
      extend ClassMethods

      has_many :detached_billables, -> { detached }, class_name: "AccountTracker::InvoiceLineItem", as: :invoiceable
    end
    
    module ClassMethods      
    end

  end
end