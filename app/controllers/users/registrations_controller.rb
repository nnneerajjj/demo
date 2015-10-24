class Users::RegistrationsController < DeviseInvitable::RegistrationsController
  before_filter :configure_permitted_parameters

  def create
    super
    if resource.save
      resource.credits = 100
      resource.save
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:avatar]
    devise_parameter_sanitizer.for(:account_update) << [:avatar]
  end
end
