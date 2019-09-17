module LikesHelper

  def like_button micropost

    if micropost.liked?(current_user)
      link_to  unlike_post_path(micropost.id), class: "btn" do
        fa_icon "heart", text: micropost.likes_count, style: "color: red"
      end
    else
      link_to  like_post_path(micropost.id), class: "btn" do
        fa_icon "heart", text: micropost.likes_count, style: "color: gray"
      end
    end

  end

end
