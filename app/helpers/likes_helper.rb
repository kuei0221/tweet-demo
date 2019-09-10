module LikesHelper

  def like_button micropost
    if micropost.liked?(current_user)
      #unlike
      link_to  unlike_micropost_path(micropost.id) do
        fa_icon "heart", text: micropost.likes_count, style: "color: red"
      end
    else
      #like
      link_to  like_micropost_path(micropost.id) do
        fa_icon "heart", text: micropost.likes_count, style: "color: gray"
      end
    end
  end
end
