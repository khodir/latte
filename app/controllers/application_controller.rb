class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  # error handling
  rescue_from ActiveModel::ValidationError, with: :handle_validation_errors
  rescue_from ActiveRecord::RecordInvalid, with: :handle_validation_errors
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  # filters
  before_action :authenticate_user!

  # inertia
  inertia_share flash: -> { flash.to_h }
  inertia_share if: :user_signed_in? do
    {
      auth: { user: current_user, perusahaan: current_perusahaan }
    }
  end

  # GET /
  def show_home
    render inertia: "home"
  end

  private
  def current_perusahaan
    @current_perusahaan ||= Perusahaan.find_by(user: current_user)
  end
end
