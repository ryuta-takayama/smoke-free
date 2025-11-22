class PostsController < ApplicationController
 
  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to dashboards_path, notice: "アクションプランを追加しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def show
    @post = Post.includes(:user, comments: :user).find(params[:id])
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: "投稿を削除しました。"
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to posts_path, notice: "投稿を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end


  private

  def post_params
    params.require(:post).permit(:body)
  end
end
