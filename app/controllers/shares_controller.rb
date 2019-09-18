class SharesController < ApplicationController

  def create
    @post = Post.find(params[:id])
    @share = current_user.share(@post, share_params[:content])
    if @share.save
      redirect_to root_url
    else
      redirect_to root_url
    end
  end

  private
  def share_params
    params.require(:post).permit(:content)
  end

end
