class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def set_place
    @regions = Place.where(ancestry: nil)
  end

  def place_param
    if params[:place][:city].present?
      params[:place][:city]
    elsif params[:place][:country].present?
      params[:place][:country]
    end
  end
  
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def check_guest
    email = resource&.email || params[:user][:email].downcase
    if email == 'guest@example.com' || email == 'guest_admin@example.com'
      redirect_to edit_user_registration_path, alert: 'ゲストユーザーの変更・削除はできません。'
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    profile_path(resource_or_scope.profile.id)
  end

end
