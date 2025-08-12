module ApplicationHelper
  def format_validation_errors(e)
    errors = {}

    if e.is_a?(ActiveModel::Errors)
      e.messages.each { |k, v| errors["#{k}"] = e.full_messages_for(k) }
    end

    errors
  end
end
