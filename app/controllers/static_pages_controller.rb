class StaticPagesController < ApplicationController
  
  def home
    if login?
      @post = current_user.posts.build
      @comment = current_user.comments.build
      @feeds = current_user.feed.includes(:liked_users, user: {avatar_attachment: :blob}).paginate(page: params[:page], per_page: 10)
    end
  end

  def about
  end

  def help
  end

  def contact
  end

end
