class Comment < ActiveRecord::Base
  
  include MuckComments::Models::MuckComment
  after_create :add_activity
  
  # TODO polish the add to activity for comment
  def add_activity
    # if !self.commentable.is_a?(Activity) # don't add comments to the activity feed that are comments on the items in the activity feed.
    content = I18n.t('muck.comments.new_comment')
    add_activity(self, self, self, 'comment', '', content)
  end

  def self.between_users user1, user2
    find(:all, {
      :order => 'created_at asc',
      :conditions => [
        "(user_id=? and commentable_id=?) or (user_id=? and commentable_id=?) and commentable_type='User'",
        user1.id, user2.id, user2.id, user1.id]
        })
  end

end
