class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  # GET /
  def show_home
    render inertia: "home"
  end

  # GET /login
  def show_login
    render inertia: "auth/login"
  end
end
