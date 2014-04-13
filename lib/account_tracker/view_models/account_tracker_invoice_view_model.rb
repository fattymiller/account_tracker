class AccountTracker::InvoiceViewModel < BaseJump::ViewModel::Base
  def page_header
    "New Invoice <small>#{owning_entity_display}</small>".html_safe
  end
  
  def form_fields
    groups = []
    
    groups << build_fields("Invoice overview", :invoice_line_items)
    groups << build_fields("Payment information", :payment_information)
    
    groups
  end
  
  def create_form_actions(form)
    actions = [submit_form_button(form)]
    actions << continue_action(data_context.line_items.first.billable_item) if data_context.line_items.size == 1
    
    actions
  end
  def continue_action(billable)
    link_to "Continue without payment", polymorphic_path(billable, ignore_payment: true), class: "btn btn-link"
  end
  
  def owning_entity_options(field_name, nested_under)
    { label: "Invoice for", readonly: true, input_html: { value: owning_entity_display } }
  end
  
  def owning_entity_display
    return owning_entity.name if owning_entity.respond_to?(:name)
    return owning_entity.format if owning_entity.respond_to?(:format)
  end

end