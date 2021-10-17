class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /profiles
  def index
    @q = Profile.ransack(params[:q])
    @profiles = @q.result(distinct: true).includes(:place).page(params[:page]).per(3)
    @chart_map = Place.joins(:profiles).group(:code).count
  end

  # GET /profiles/1
  def show
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

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1/edit
  def edit
    unless @profile.user == current_user
      redirect_to @profile, alert: "ユーザー本人以外は編集できません"
    end
    @regions = Place.where(ancestry: nil)
  end

  # POST /profiles
  def create
    @profile = Profile.new(profile_params)
    @profile.user_id = current_user.id
    if @profile.save
      redirect_to @profile, notice: t('notice.create', model: t('profile'))
    else
      render :new
    end
  end

  # PATCH/PUT /profiles/1
  def update
    @profile.place_id = place_param
    if @profile.update(profile_params)
      redirect_to @profile, notice: t('notice.update', model: t('profile'))
    else
      redirect_to edit_profile_path, alert: "国名が未入力です！！"
      # render :edit
    end
  end

  # DELETE /profiles/1
  def destroy
    @profile.destroy
    redirect_to profiles_url, notice: t('notice.destroy', model: t('profile'))
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
      # @profile = Profile.find_by(user_id:params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def profile_params
      params.require(:profile).permit(:icon, :icon_cache, :gender, :birthday, :first_language, :second_language, :introduction)
    end

    def place_param
      if params[:place][:city].present?
        params[:place][:city]
      elsif params[:place][:country].present?
        params[:place][:country]
      else params[:place][:area].present?
        params[:place][:area]
      end
    end

end
