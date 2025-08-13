class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  # filters
  before_action :authenticate_user!

  # inertia
  inertia_share auth: -> { { user: current_user } }

  # GET /
  def show_home
    render inertia: "home"
  end
end
