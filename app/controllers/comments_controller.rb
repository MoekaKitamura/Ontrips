class CommentsController < ApplicationController
  # コメントを保存、投稿する
  before_action :set_trip, only: [:create, :edit, :update]
  def create
    # tripをパラメータの値から探し出し,tripに紐づくcommentsとしてbuild
    @comment = @trip.comments.build(comment_params) #@tripのidをtrip_idに含んだ状態のCommentインスタンスをnew(作成)
    @comment.user_id = current_user.id
    # クライアント要求に応じてフォーマットを変更
    respond_to do |format|
      if @comment.save
        format.js { render :index } #index.js.erbへrender
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
