class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  #return the microposts from users followed by "self"
  def self.from_users_followed_by(user)
  	#return all the followed users
    followed_user_ids = user.followed_user_ids
    #return the microposts from the user or followed users
    where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
  end
end
