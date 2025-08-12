module ApplicationHelper
  def format_validation_errors(e)
    errors = {}

    if e.is_a?(ActiveModel::Errors)
      e.messages.each { |k, v| errors["#{k}"] = e.full_messages_for(k) }
    end

    errors
  end

  def handle_validation_errors(e)
    if e.is_a?(ActiveModel::ValidationError)
      messages = format_validation_errors(e.model.errors)
      redirect_back fallback_location: root_path, inertia: { errors: messages }
    end

    if e.is_a?(ActiveRecord::RecordInvalid)
      messages = format_validation_errors(e.record.errors)
      redirect_back fallback_location: root_path, inertia: { errors: messages }
    end
  end
end
