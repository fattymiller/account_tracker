class AccountTracker::AccountViewModel < BaseJump::ViewModel::Base
  def index_scopes
    [
      { :scope => :overdue, :count_class => "label-danger", :path => account_tracker_accounts_path(:scope => :overdue), :hide_when_empty => true }, 
      { :scope => :outstanding, :count_class => "label-warning", :path => account_tracker_accounts_path(:scope => :outstanding) }
    ]
  end
  
end