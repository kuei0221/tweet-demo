module UsersHelper

  def edit_button user
    if current_user? user
      link_to "Edit", edit_user_path(user), class: "btn btn-sm btn-secondary"
    end
  end

  def delete_button user
    if login? && current_user.admin? && !user.admin
      link_to "delete", user_path(user), method: "delete", data:{ confirmation: "Are you sure?"} 
    end
  end

  def show_avatar user, style=nil, size=nil
    if user.avatar.attached?
      image_tag user.avatar, class: style, style: size
    end
  end

  def show_feed feeds
    if feeds.any?
      concat will_paginate feeds
      render partial: "posts/post", collection: feeds, cached: -> post {[post, post.user, current_user]}
    end
  end
end