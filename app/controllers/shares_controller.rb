class SharesController < ApplicationController

  def create
    @post = Post.find(params[:id])
    @share = current_user.share(@post, share_params[:content])

    respond_to do |format|
      
      if @share.save
        flash[:success] = "You have success share this post"
        format.js
      else
        flash[:danger] = "You can't share this post!"
      end
      
      format.html { redirect_back fallback_location: root_path }
    end

  end

  private
  def share_params
    params.require(:micropost).permit(:content)
  end

end
