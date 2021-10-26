class TripsController < ApplicationController
  before_action :set_trip, only: %i[show edit update destroy change_goal]
  before_action :authenticate_user!
  before_action :set_place, only: %i[new create edit update]

  # GET /trips
  def index
    @q = Trip.ransack(params[:q])
    @trips = @q.result(distinct: true).includes(:place).order(updated_at: :desc).page(params[:page]).per(4)
  end

  # GET /trips/1
  def show
    country_or_city(@trip)
    @favorite = current_user.favorites.find_by(trip_id: @trip.id)
    @member = current_user.members.find_by(trip_id: @trip.id)
    @members = @trip.members
    @comments = @trip.comments
    @comment = @trip.comments.build
    @similar = Trip.where(place_id: @country.id).or(Trip.where(place_id: @country.child_ids))
                  .where.not(id: @trip.id).where(goal: false).order(updated_at: :desc).limit(3)
    @visiters = @members.where(as: 1).count
    @locals = @members.where(as: 2).count
    # map ---
    @from = @trip.user.profile.place
    @to = @trip.place
    @middle = Geocoder::Calculations.geographic_center([@to,@from]) #中間地点
    # @date = Date.today.strftime('%Y%m%d').to_i - @trip.created_at.strftime('%Y%m%d').to_i
    @duration = ((Time.zone.now - @trip.created_at) / 3600).to_i
  end

  def change_goal
    @trip.update(goal: params[:goal])
    redirect_to @trip, notice: t('notice.change', word: t('status'))
  end

  def favorite
    @favorites = current_user.favorites.page(params[:page]).per(3)
  end

  def member
    @joining = current_user.members.page(params[:page]).per(3)
  end

  # GET /trips/new
  def new
    @trip = Trip.new
  end

  # GET /trips/1/edit
  def edit
    # 目的地がcityだったら
    params[:place] = {"region"=>@trip.place.root.id, "country"=>@trip.place.parent.id, "city"=>@trip.place.id} if @trip.place.ancestry&.include?('/')
    # 目的地がcountryだったら
    params[:place] = {"region"=>@trip.place.root.id, "country"=>@trip.place.id} if @trip.place.root == @trip.place.parent  
    unless @trip.user == current_user
      redirect_to @trip, alert: "投稿者以外は編集できません"
    end
  end

  # POST /trips
  def create
    @trip = Trip.new(trip_params)
    @trip.user_id = current_user.id
    @trip.place_id = place_param
    if @trip.save
      redirect_to @trip, notice: t('notice.create', model: t('trip'))
    else
      render :new
    end
  end

  # PATCH/PUT /trips/1
  def update
    @trip.place_id = place_param
    if @trip.update(trip_params)
        redirect_to @trip, notice: t('notice.update', model: t('trip'))
    else
      render :edit
    end
  end

  # DELETE /trips/1
  def destroy
    @trip.destroy
    redirect_to trips_url, notice: t('notice.destroy', model: t('trip'))
  end

  private
  def set_trip
    @trip = Trip.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(:title, :start_on, :finish_on, :flexible, :description, :goal)
  end

  def country_or_city(table)
    if table.place.ancestry&.include?('/')
      @country = table.place.parent
      @city = table.place
    else
      @country = table.place
    end
  end
end