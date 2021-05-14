require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @unread_notification = notifications(:unread)
    @read_notification = notifications(:read)
  end

  test "should get all notifications" do
    get notifications_url, as: :json, headers: auth_header(@user)
    assert_response :success
    assert_pagination
    assert_equal 2, response.parsed_body['pagination']['total_count']
    assert_equal 2, response.parsed_body['pagination']['total_count']

    results = response.parsed_body['results']
    notification = results.find { |result| result['id'] == @unread_notification.id }
    assert_equal @unread_notification.message, notification['message']
    assert_equal @unread_notification.read_at, notification['read_at']
    assert_equal @unread_notification.actor.username, notification['actor']['username']
    assert_equal @unread_notification.actor.image, notification['actor']['image']
    assert_equal @unread_notification.actor.bio, notification['actor']['bio']
  end

  test "should mark notification as read" do
    params = {
      notification: {
        read: true
      }
    }

    refute @unread_notification.read_at
    patch notification_url(@unread_notification), params: params, as: :json, headers: auth_header(@user)

    assert_response :success
    assert @unread_notification.reload.read_at
  end
end
