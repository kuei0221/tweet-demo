class PostsController < ApplicationController
  
  before_action :is_login?, only: [:create]
  before_action :correct_author, only: [:destroy]

  def show
    @post = Micropost.includes(:liked_users, :sharing, user:{avatar_attachment: :blob}).find_by(id: params[:id])
    @comments = @post.comments.includes(:liked_users, user: {avatar_attachment: :blob} ).all
    @comment = Comment.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Create Post success"
      redirect_to root_url
    else
      @feeds = current_user.feed.includes(:liked_users, user: {avatar_attachment: :blob}).paginate(page: params[:page], per_page: 15)
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
