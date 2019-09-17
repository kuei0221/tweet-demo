# class MicropostsController < ApplicationController
  
#   before_action :is_login?, only: [:create]
#   before_action :correct_author, only: [:destroy]

#   def create
#     @micropost = current_user.microposts.build(micropost_params)
#     if @micropost.save
#       flash[:success] = "Create Post success"
#       redirect_to root_url
#     else
#       @feeds = current_user.feed.includes(:liked_users, user: {avatar_attachment: :blob}).paginate(page: params[:page], per_page: 15)
#       flash[:danger] = "Invalid post"
#       redirect_back fallback_location: root_url
#     end
#   end

#   def destroy
#     @micropost.destroy
#     redirect_to current_user
#   end

#   private

#   def micropost_params
#     params.require(:micropost).permit(:content, :picture)
#   end

#   def correct_author
#     @micropost = current_user.microposts.find_by(id: params[:id])
#     redirect_to root_url if @micropost.nil?
#   end
# end
