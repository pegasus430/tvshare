require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @comment = comments(:one)
    @sub_comment = sub_comments(:one)
    @story = stories(:one)
    @message = "I find this inappropriate"
    @url = 'http://example.com'
  end

  test "can report a user" do
    ReportMailer.any_instance.expects(:report_content).once.returns(true)

    params = {
      reportable_type: 'User',
      reportable_id: @user.id,
      message: @message,
      url: @url
    }

    assert_difference '@user.reports.count' do
      post report_url, params: params, as: :json, headers: auth_header(@user)
    end

    assert_response :success
    @report = Report.last
    assert_equal @report.message, @message
    assert_equal @report.url, @url
  end

  test "can report a comment" do
    ReportMailer.any_instance.expects(:report_content).once.returns(true)

    params = {
      reportable_type: 'Comment',
      reportable_id: @comment.id,
      message: @message
    }

    assert_difference '@comment.reports.count' do
      post report_url, params: params, as: :json, headers: auth_header(@user)
    end
    assert_response :success
  end

  test "can report a sub comment" do
    ReportMailer.any_instance.expects(:report_content).once.returns(true)

    params = {
      reportable_type: 'SubComment',
      reportable_id: @sub_comment.id,
      message: @message
    }

    assert_difference '@sub_comment.reports.count' do
      post report_url, params: params, as: :json, headers: auth_header(@user)
    end
    assert_response :success
  end

  test "can report a story" do
    ReportMailer.any_instance.expects(:report_content).once.returns(true)

    params = {
      reportable_type: 'Story',
      reportable_id: @story.id,
      message: @message
    }

    assert_difference '@story.reports.count' do
      post report_url, params: params, as: :json, headers: auth_header(@user)
    end
    assert_response :success
  end

  test "can not report when not logged in" do
    ReportMailer.any_instance.expects(:report_content).never

    params = {
      reportable_type: 'Story',
      reportable_id: @story.id,
      message: @message
    }

    assert_no_difference '@story.reports.count' do
      post report_url, params: params, as: :json
    end
    assert_response :unauthorized
  end
end
