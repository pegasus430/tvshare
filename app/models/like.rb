class Like < ApplicationRecord
  belongs_to :user, counter_cache: true, optional: true
  belongs_to :comment, optional: true, counter_cache: true
  belongs_to :show, optional: true, counter_cache: true
  belongs_to :sub_comment, optional: true, counter_cache: true
  belongs_to :story, optional: true, counter_cache: true

  after_create :create_notification

  scope :for_shows, -> { where.not(show_id: nil) }

  private

  def create_notification
    if comment_id
      message = "#{user.username} liked your comment"
      comment.notifications.create(actor: user, message: message)
    elsif sub_comment_id
      message = "#{user.username} liked your reply"
      sub_comment.notifications.create(actor: user, message: message)
    end
  end
end
