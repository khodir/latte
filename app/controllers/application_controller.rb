class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  # error handling
  rescue_from ActiveModel::ValidationError, with: :handle_validation_errors
  rescue_from ActiveRecord::RecordInvalid, with: :handle_validation_errors

  # filters
  before_action :authenticate_user!

  # inertia
  inertia_share flash: -> { flash.to_h }
  inertia_share if: :user_signed_in? do
    {
      auth: { user: current_user }
    }
  end

  # GET /
  def show_home
    render inertia: "home"
  end
end
