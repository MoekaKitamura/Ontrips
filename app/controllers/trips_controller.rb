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
    # show_region(@trip)
    # show_country(@trip)
    # show_city(@trip)
    country_or_city(@trip)
    @favorite = current_user.favorites.find_by(trip_id: @trip.id)
    @member = current_user.members.find_by(trip_id: @trip.id)
    @members = @trip.members
    @comments = @trip.comments
    @comment = @trip.comments.build
    @similar = Trip.where(place_id: @country.id).where.not(id: @trip.id).order(updated_at: :desc).limit(3)
    @visiters = @members.where(as: 1).count
    @locals = @members.where(as: 2).count
    # map ---
    @from = @trip.user.profile.place
    @to = @trip.place
    @middle = Geocoder::Calculations.geographic_center([@to,@from]) #中間地点
  end

  def change_goal
    #旅行を終了する
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
    @regions = Place.where(ancestry: nil)
  end

  # GET /trips/1/edit
  def edit
    unless @trip.user == current_user
      redirect_to @trip, alert: "投稿者以外は編集できません"
    end
    @regions = Place.where(ancestry: nil)
  end

  # POST /trips
  def create
    @trip = Trip.new(trip_params)
    @trip.user_id = current_user.id
    @trip.place_id = place_param
    if @trip.save
      redirect_to @trip, notice: t('notice.create', model: t('trip'))
    else
      redirect_to new_trip_path, alert: "国名が未入力です！！"
      # render :new
    end
  end

  # PATCH/PUT /trips/1
  def update
    @trip.place_id = place_param
    if @trip.update(trip_params)
      redirect_to @trip, notice: t('notice.update', model: t('trip'))
    else
      redirect_to edit_trip_path, alert: "国名が未入力です！！"
      # render :edit
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
      params.require(:trip).permit(:title, :start_on, :finish_on, :flexible, :description, :goal)
    end

    def place_param
      if params[:place][:city].present?
        params[:place][:city]
      elsif params[:place][:country].present?
        params[:place][:country]
      # else params[:place][:area].present? #
      #   params[:place][:area]
      end
    end

    # def show_region(table)
    #   if table.place.ancestry.nil?
    #     @region = table.place
    #   elsif table.place.ancestry&.length == 1
    #     @region = table.place.parent
    #   elsif table.place.ancestry&.include?('/')
    #     @region = table.place.parent.parent
    #   end
    # end

    def country_or_city(table)
      if table.place.ancestry&.include?('/')
        @country = table.place.parent
        @city = table.place
      else
        @country = table.place
      end
    end

    # def show_city(table)
    #   if table.place.ancestry&.include?('/')
    #     @city = table.place
    #   end
    # end
end