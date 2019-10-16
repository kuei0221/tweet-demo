class PostsController < ApplicationController
  
  before_action :is_login?, only: [:create]
  before_action :correct_author, only: [:destroy]

  def show
    @post = Post.includes(:liked_users, :sharing, user:{avatar_attachment: :blob}).find_by(id: params[:id])
    @comments = @post.comments.includes(:liked_users, user: {avatar_attachment: :blob} ).all
    # @comment = Comment.new
    # which is better? create a empty instance vairable or create in form?
  end

  def create
    @post = current_user.posts.build(post_params)
    respond_to do |format|
      if @post.save
        flash[:success] = "Create Post success"
        format.js
        format.html { redirect_to root_url }
      else
        flash[:danger] = "Invalid post"
        format.html {redirect_back fallback_location: root_url}
      end
    end
  end

  def destroy
    @post.destroy
    redirect_to current_user
  end

  private

  def post_params
    params.require(:post).permit(:content, :picture)
  end

  def correct_author
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end
end
