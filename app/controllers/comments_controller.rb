class CommentsController < ApplicationController

  def create
    @post = Post.find params[:id]
    @comment = current_user.comment @post, comment_params[:content]
    
    respond_to do |format|
      if @comment.save
        format.js
      else
        flash[:danger] = "Comment fail"
      end
      format.html { redirect_back fallback_location: root_path }
    end

  end

  private

  def comment_params
    params.require(:micropost).permit(:content)
  end
end
