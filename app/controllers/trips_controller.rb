class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy, :change_goal]
  before_action :authenticate_user!

  # GET /trips
  def index
    @q = Trip.ransack(params[:q])
    @trips = @q.result(distinct: true).page(params[:page]).per(3)
    # @trips = Trip.all
  end

  # GET /trips/1
  def show
    @favorite = current_user.favorites.find_by(trip_id: @trip.id)
    @member = current_user.members.find_by(trip_id: @trip.id)
    @members = @trip.members
    @comments = @trip.comments
    @comment = @trip.comments.build
    @similar = Trip.where(country: @trip.country).where.not(id: @trip.id)
  end

  def change_goal
    #旅行を終了する
    @trip.update(goal: params[:goal])
    redirect_to @trip, notice: 'ステータスを変更しました。'
  end

  # GET /trips/new
  def new
    @trip = Trip.new
  end

  # GET /trips/1/edit
  def edit
  end

  # POST /trips
  def create
    @trip = Trip.new(trip_params)
    @trip.user_id = current_user.id
    if @trip.save
      redirect_to @trip, notice: t('notice.create', model: t('trip'))
    else
      render :new
    end
  end

  # PATCH/PUT /trips/1
  def update
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
    # Use callbacks to share common setup or constraints between actions.
    def set_trip
      @trip = Trip.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def trip_params
      params.require(:trip).permit(:title, :country, :city, :start_on, :finish_on, :flexible, :description, :goal)
    end
end
