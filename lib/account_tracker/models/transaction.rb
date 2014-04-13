module AccountTracker
  class Transaction < ActiveRecord::Base
    serialize :params
    
  end
end