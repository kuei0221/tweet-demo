module RelationshipsHelper

  # to get whether the relationship is passive or not. If is, would not showing anything
  def is_passive_relationship?(relationship)
    relationship == :followers
  end

  #not showing anyting if: 1. looking at your followers 2. looking at yourself 3. not login
  def check_follow_button(user)
    not is_passive_relationship?(@relationship) && params[:id] == current_user.id.to_s || current_user?(user) || !login?
  end
  
  def follow_button_path(user)
    current_user.follow?(user) ? "users/unfollow" : "users/follow"
  end

  def follow_button_html(user)
    render follow_button_path(user), user: user if check_follow_button user  
  end


end