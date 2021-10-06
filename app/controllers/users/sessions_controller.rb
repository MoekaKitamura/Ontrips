class Users::SessionsController < Devise::SessionsController
  def new_guest
    user = User.guest
    unless Profile.find(user.id).present?
      @profile = user.build_profile(id: user.id)
      @profile.save
    end
    sign_in user
    redirect_to trips_path, notice: 'ゲストユーザーとしてログインしました。'
  end
end