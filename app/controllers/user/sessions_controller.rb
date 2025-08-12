# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  include ApplicationHelper
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    render inertia: "auth/login"
  end

  # POST /resource/sign_in
  def create
    p = params.permit(:email, :password)
    creds = UserLoginRequest.new(email: p[:email], password: p[:password])

    unless creds.valid?
      redirect_to new_user_session_url, inertia: { errors: format_validation_errors(creds.errors) }
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
