class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_guest, only: %i[update destroy]

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    confirm_email_path
  end

  def confirm_email
  end

end