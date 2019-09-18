module PostsHelper

  def show_sharing_post(post)

    if post.sharing.present?
      render "shares/share", share: post.sharing
    else
      return nil
    end

  end
  
end