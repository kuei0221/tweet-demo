class StaticPagesController < ApplicationController
  
  def home
    if login?
      @micropost = current_user.microposts.build 
      @feeds = current_user.feed.includes(:likers, user: {avatar_attachment: :blob}).paginate(page: params[:page], per_page: 15)
    end
  end

  def about
  end

  def help
  end

  def contact
  end

end
