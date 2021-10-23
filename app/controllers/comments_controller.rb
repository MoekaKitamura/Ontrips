class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trip, only: %i[create edit update]

  def create
    @comment = @trip.comments.build(comment_params)
    @comment.user_id = current_user.id
    respond_to do |format|
      if @comment.save
        format.js { render :index }
      else
        format.html { redirect_to trip_path(@trip), alert: 'コメントを入力してください' }
      end
    end
  end

  def edit
    @comment = @trip.comments.find(params[:id])
    respond_to do |format|
      flash.now[:notice] = 'コメントの編集中'
      format.js { render :edit }
    end
  end

  def update
    @comment = @trip.comments.find(params[:id])
    respond_to do |format|
      if @comment.update(comment_params)
        flash.now[:notice] = t('notice.update', model: t('comment'))
        format.js { render :index }
      else
        flash.now[:notice] = 'コメントの編集に失敗しました'
        format.js { render :edit_error }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      flash.now[:notice] = t('notice.destroy', model: t('comment'))
      format.js { render :index }
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:trip_id, :content)
  end

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

end
