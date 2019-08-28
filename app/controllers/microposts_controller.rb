class MicropostsController < ApplicationController
  
  before_action :is_login?, only: [:create]
  before_action :correct_author, only: [:destroy]

  def create
    @micropost = current_user.microposts.build(content: micropost_params[:content])
    if @micropost.save
      flash[:success] = "Create Post success"
      redirect_to root_url
    else
      @feed_items = []
      flash.now[:danger] = "Invalid post"
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy
    redirect_to current_user
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content)
  end

  def correct_author
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
