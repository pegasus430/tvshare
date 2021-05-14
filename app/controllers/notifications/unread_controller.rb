class Notifications::UnreadController < ApplicationController
  before_action :authorize_request

  def index
    @notifications = @current_user.notifications.unread.order(id: :desc).page(params[:page])
    render 'notifications/index'
  end

  def update
    @current_user.notifications.unread.update_all(read_at: Time.current)
    head(:ok)
  end
end
