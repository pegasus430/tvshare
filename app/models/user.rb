class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_secure_password
  include Reportable

  validate :password_complexity

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  has_many :comments, dependent: :destroy
  has_many :sub_comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :shares
  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followed_users, through: :active_relationships, source: :followed_user
  has_many :followers, through: :passive_relationships, source: :follower_user
  has_many :notifications, foreign_key: :owner_id # notifications where this user is the recipient

  def generate_reset_password_token
    self.password_reset_token = SecureRandom.urlsafe_base64(32)
    self.password_reset_token_expiration = 3.days.from_now
    self.save!
    UserMailer.with(user: self).reset_password.deliver_now
  end

  def self.reset_password(token, new_password, new_password_confirmation)
    user = User.where('password_reset_token_expiration > ?', Time.current).find_by!(password_reset_token: token)
    user.password = new_password
    user.password_confirmation = new_password_confirmation
    user.password_reset_token = nil
    user.password_reset_token_expiration = nil
    user.save!
  end

  private
  def password_complexity
    return if password.blank? || password =~ /\A(?=.*\d)(?=.*[A-Z])(?=.*\W)[^ ]{7,}\z/

    errors.add :password, 'Password should have more than 7 characters including 1 uppercase letter, 1 number, 1 special character'
  end
end
