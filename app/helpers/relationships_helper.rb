module RelationshipsHelper

  # to get whether the relationship is passive or not. If is, would not showing anything
  def is_passive_relationship?
    @relationship == :followers
  end

  def is_following? other_user
    #if the current_user didnt load following first, will have n+1 problem
    current_user.follow?(other_user) ? "users/unfollow" : "users/follow"
  end

  def follow_button_html user
    if !login?
      return nil #need login
    elsif current_user? user
      return nil #no button for yourself
    elsif is_passive_relationship? && params[:id] == current_user.id.to_s
      return nil #no button for your followers' page
    else
      render is_following?(user), user: user
    end
  end


end