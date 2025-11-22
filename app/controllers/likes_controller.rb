class LikesController < ApplicationController
  before_action :set_post

  def create
    toggle_like
    respond_to do |format|
      format.turbo_stream { render turbo_stream: render_like_panel }
      format.html { redirect_back fallback_location: @post }
    end
  end

  def destroy
    current_user.likes.find_by(post: @post)&.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: render_like_panel }
      format.html { redirect_back fallback_location: @post }
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def toggle_like
    if (existing = current_user.likes.find_by(post: @post))
      existing.destroy
    else
      current_user.likes.create(post: @post)
    end
  end

  def render_like_panel
    turbo_stream.replace(view_context.dom_id(@post, :like_panel),
      partial: "posts/like_panel",
      locals: { post: @post })
  end
end
