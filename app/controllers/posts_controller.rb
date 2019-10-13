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
    if @post.save
      flash[:success] = "Create Post success"
      redirect_to root_url
    else
      @feeds_collection = current_user.feed.includes(:liked_users, user: {avatar_attachment: :blob})
      @pagy, @feeds = pagy(@feeds_collection)
      flash[:danger] = "Invalid post"
      redirect_back fallback_location: root_url
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
