class Users::RegistrationsController < Devise::RegistrationsController
  before_action :check_guest, only: %i[update destroy]

  def create
    super
    @profile = @user.build_profile(id: @user.id)
    @profile.save
  end
end