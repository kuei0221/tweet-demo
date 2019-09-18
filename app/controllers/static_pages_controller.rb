class StaticPagesController < ApplicationController
  
  def home
    if login?
      @post = current_user.posts.build
      @share = current_user.posts.build
      @comment = current_user.comments.build
      @feeds = current_user.feed.paginate(page: params[:page], per_page: 10)
    end
  end

  def about
  end

  def help
  end

  def contact
  end

end
