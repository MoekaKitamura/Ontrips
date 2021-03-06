class Users::SessionsController < Devise::SessionsController
  def new_guest
    user = User.guest
    sign_in user
    redirect_to profile_path(user.profile.id), notice: 'ゲストユーザーとしてログインしました'
  end

  def new_guest_admin
    user = User.guest_admin
    sign_in user
    redirect_to profile_path(user.profile.id), notice: 'ゲスト管理者ユーザーとしてログインしました'
  end
end

# プロフィールを消す
# Profile.find(user.id).destroy if Profile.where(id: user.id).present?
# @profile = user.build_profile(id: user.id)
# @profile.save

# 他のデータも抹消
# if Profile.where(id: user.id).present?
#   Profile.find(user.id).destroy
#   Blog.where(user.id).destroy_all
#   Blog.where(user.id).destroy_all
#   Blog.where(user.id).destroy_all
#   Blog.where(user.id).destroy_all
# end
# @profile = user.build_profile(id: user.id)
# @profile.save