module LikesHelper

  def like_button micropost

    if micropost.liked? current_user
      color = "red"
      like = false
    else
      color = "gray"
      like = true
    end

    link_to like_post_path(micropost.id, like: like), method: "patch", class: "btn" do #update path
      fa_icon "heart", text: micropost.likes_count, style: "color: #{color}"
    end

  end

end
