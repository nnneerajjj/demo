class Users::RegistrationsController < DeviseInvitable::RegistrationsController
  before_filter :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:avatar]
    devise_parameter_sanitizer.for(:account_update) << [:avatar]
  end
end
