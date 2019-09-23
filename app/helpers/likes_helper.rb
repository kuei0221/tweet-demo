module LikesHelper

  def like_button_params(micropost)
    if micropost.liked? current_user
      color = "red"
      like_action = "unlike"
    else
      color = "gray"
      like_action = "like"
    end
    return { color: color, like_action: like_action}
  end

  def like_button(micropost)

    params = like_button_params micropost
    link_to like_post_path(micropost.id, like_action: params[:like_action]), method: "patch", class: "btn", remote: true do
      fa_icon "heart", text: micropost.likes_count, style: "color: #{params[:color]}", id: "like-icon"
    end

  end

end
