class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[show edit update]
  before_action :authenticate_user!
  before_action :set_place, only: %i[edit update]

  # GET /profiles
  def index
    @q = Profile.ransack(params[:q])
    @profiles = @q.result(distinct: true).includes(:place).order(updated_at: :desc).page(params[:page]).per(12)
    @chart_map = Place.joins(:profiles).group(:code).count
  end

  # GET /profiles/1
  def show
    @trips = @profile.user.trips.order(updated_at: :desc).limit(4)
    @joining = @profile.user.members.order(updated_at: :desc).limit(4)
    @blogs = @profile.user.blogs.order(updated_at: :desc).limit(4)
    if @profile.place.ancestry&.include?('/')
      @code = @profile.place.parent.code.downcase 
    elsif @profile.place.root?
      @code = nil
    else
      @code = @profile.place.code.downcase
    end
  end

  # GET /profiles/1/edit
  def edit
    # 居住地がcityだったら
    params[:place] = {"region"=>@profile.place.root.id, "country"=>@profile.place.parent.id, "city"=>@profile.place.id} if @profile.place.ancestry&.include?('/')
    # 居住地がcountryだったら
    params[:place] = {"region"=>@profile.place.root.id, "country"=>@profile.place.id} if @profile.place.root == @profile.place.parent  
    unless @profile.user == current_user
      redirect_to @profile, alert: "ユーザー本人以外は編集できません"
    end
  end

  # PATCH/PUT /profiles/1
  def update
    @profile.place_id = place_param
    if @profile.update(profile_params)
      redirect_to @profile, notice: t('notice.update', model: t('profile'))
    else
      render :edit
    end
  end

  private
  def set_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:icon, :icon_cache, :gender, :birthday, :first_language, :second_language, :introduction)
  end

end
