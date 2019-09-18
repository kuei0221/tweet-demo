class CommentsController < ApplicationController

  def create
    @comment = current_user.comments.build(content: comment_params[:content], post_id: params[:id])
    if @comment.save
      redirect_to post_path params[:id]
    else
      flash[:danger] = "Comment fail"
      redirect_back fallback_location: root_path
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
