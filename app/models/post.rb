class Post < Micropost
  has_many :comments

  has_one :sharing_relationship, class_name: "Share", foreign_key: "shared_id"
  has_one :sharing, through: :sharing_relationship, source: :sharing

  has_many :shared_relationship, class_name: "Share", foreign_key: "sharing_id"
  has_many :shared, through: :shared_relationship, source: :shared

  default_scope -> { order(created_at: :desc)}
  scope :feed, -> (user) { where("user_id IN (?) or user_id = ? ", user.following_ids, user.id) }

end


# click link to share controller 
#call user.share post
#modle user#share do something... call post#shared..?

#Share does the same as Post, only different is contain another post info, therefore should have other post info
#Need to make it into association, otherwise have to load again and again
#one post can have many shares, but one shares only have one sources.
# Sharing post to find shared post
