class StaticPagesController < ApplicationController
  
  def home
    if login?
      @post = Post.new
      @share = current_user.share
      @comment = current_user.comment
      @feeds_collection = current_user.feed
      @pagy, @feeds = pagy(@feeds_collection)
    end
  end

  def about
  end

  def help
  end

  def contact
  end

  def privacy
  end

end
