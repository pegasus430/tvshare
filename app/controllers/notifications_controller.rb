class NotificationsController < ApplicationController
  before_action :authorize_request

  def index
    @notifications = @current_user.notifications.order(id: :desc).page(params[:page])
  end

  def update
    @notification = @current_user.notifications.find(params[:id])
    @notification.read_at = Time.current
    @notification.save!

    head(:ok)
  end
end
