class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: :destroy

  def create
    @comment = current_user.comments.build(comment_params.merge(post: @post))

    if @comment.save
      respond_to do |format|
        format.turbo_stream { render_comment_panel }
        format.html { redirect_to post_path(@post), notice: "コメントを投稿しました。" }
      end
    else
      respond_to do |format|
        format.turbo_stream { render_comment_panel(status: :unprocessable_entity) }
        format.html do
          flash.now[:alert] = "コメントの投稿に失敗しました。"
          render "posts/show", status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    @comment.destroy

    respond_to do |format|
      format.turbo_stream { render_comment_panel }
      format.html { redirect_to post_path(@post), notice: "コメントを削除しました。" }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def render_comment_panel(status: :ok)
    render turbo_stream: turbo_stream.replace(
      view_context.dom_id(@post, :comments_panel),
      partial: "comments/panel",
      locals: { post: @post, comments: @post.comments.includes(:user) }
    ), status: status
  end
end
