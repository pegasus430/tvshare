class SubComment < ApplicationRecord
  include Reportable
  include Notifiable

  belongs_to :comment, counter_cache: true, optional: true
  belongs_to :sub_comment, counter_cache: true, optional: true
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :sub_comments, dependent: :destroy
  has_many :shares, as: :shareable

  after_create :create_notification

  private

  def create_notification
    if comment_id
      message = "#{user.username} replied to your comment"
      comment.notifications.create(actor: user, message: message)
    elsif sub_comment_id
      message = "#{user.username} replied to your response"
      sub_comment.notifications.create(actor: user, message: message)
    end
  end

end
