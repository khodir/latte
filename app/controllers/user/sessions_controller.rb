# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  include ApplicationHelper
  # before_action :configure_sign_in_params, only: [:create]

  rescue_from ActiveModel::ValidationError, with: :handle_validation_errors

  # GET /resource/sign_in
  def new
    render inertia: "auth/login"
  end

  # POST /resource/sign_in
  def create
    p = params.permit(:email, :password, :remember_me)
    creds = UserLoginRequest.new(p.to_h)
    creds.validate!

    @user = User.find_by(email: creds.email)
    return redirect_back fallback_location: root_path, inertia: { errors: { email: [ "Invalid Email or Password" ] } } if @user.nil?

    if @user&.valid_password?(creds.password)
      @user.update_tracked_fields!(request)
      @user.save!

      sign_in(@user)
      remember_me(@user) if creds.remember_me
      redirect_to root_path, inertia: { flash: { notice: "Signed in successfully." } }
    else
      redirect_back fallback_location: root_path, inertia: { errors: format_validation_errors(@user&.errors || creds.errors) }
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
