class StaticPagesController < ApplicationController
  
  def home
    if login?
      @micropost = current_user.microposts.build 
      @feed_items = current_user.feed.includes(user: {avatar_attachment: :blob}).with_attached_picture.paginate(page: params[:page], per_page: 15)
    end
  end

  def about
  end

  def help
  end

  def contact
  end

end
