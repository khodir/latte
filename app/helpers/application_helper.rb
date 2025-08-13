module ApplicationHelper
  # Handle Not Found
  def handle_not_found(e)
    flash[:alert] = e.message
    redirect_back fallback_location: root_path
  end

  # Handle Model Errors
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

  # Format Validation Errors
  def format_validation_errors(e)
    errors = {}

    if e.is_a?(ActiveModel::Errors)
      e.messages.each { |k, v| errors["#{k}"] = e.full_messages_for(k) }
    end

    errors
  end

  # encrypt text
  def encrypt_and_sign(text)
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials.secret_key_base[0..31])
    crypt.encrypt_and_sign(text)
  end

  # decrypt text
  def decrypt_and_verify(text)
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials.secret_key_base[0..31])
    crypt.decrypt_and_verify(text)
  end

  # pagination
  def paginate(total)
    c_page = params[:page].nil? ? 1 : params[:page].to_i
    per_page = params[:per_page].nil? ? 10 : params[:per_page].to_i

    last_page = (total.to_f / per_page.to_f).ceil
    last_page = 1 if last_page == 0

    c_page = last_page if c_page > last_page
    c_page = 1 if c_page == 0

    from = ((c_page - 1) * per_page) + 1
    from = total if from > total

    to = from + per_page - 1
    to = total if to > total

    skip = from - 1
    skip = 0 if from == 0

    {
      total: total,
      last_page: last_page,
      current_page: c_page,
      from: from,
      to: to,
      per_page: per_page,
      skip: skip
    }
  end
end
