class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_guest, only: %i[update destroy]

  def create
    super
    @profile = @user.build_profile(id: @user.id)
    @profile.save
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    letter_opener_web_path if Rails.env.development?
  end

end