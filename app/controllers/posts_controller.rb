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


  private

  def post_params
    params.require(:post).permit(:body)
  end
end
