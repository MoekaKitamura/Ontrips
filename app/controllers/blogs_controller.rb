class BlogsController < ApplicationController
  before_action :set_blog, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  def index
    @q = Blog.ransack(params[:q])
    @blogs = @q.result(distinct: true)
    # @blogs = Blog.all
  end

  def show
  end

  def new
    @blog = Blog.new
  end

  def edit
    unless @blog.user == current_user
      redirect_to @blog, alert: "投稿者以外は編集できません"
    end
  end

  def create
    @blog = Blog.new(blog_params)
    @blog.user_id = current_user.id
    if @blog.save
      redirect_to @blog, notice: t('notice.create', model: t('blog'))
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @blog.update(blog_params)
      redirect_to @blog, notice: t('notice.update', model: t('blog'))
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @blog.destroy
    redirect_to blogs_url, notice: t('notice.destroy', model: t('blog'))
  end

  private
  def set_blog
    @blog = Blog.find(params[:id])
  end

  def blog_params
    params.require(:blog).permit(:title, :content)
  end
end
