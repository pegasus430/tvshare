require 'test_helper'

class SubCommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @comment = comments(:one)
    @sub_comment = sub_comments(:one)
  end

  test "should get index for show with comment_id" do
    get sub_comments_url(comment_id: @comment.id), as: :json, headers: auth_header(@user)
    assert_response :success
    assert_pagination

    assert_equal 2, @comment.sub_comments.count
    assert_equal @comment.sub_comments.count, response.parsed_body['results'].count
    assert_equal @comment.sub_comments.map(&:id), response.parsed_body['results'].map { |json| json['id'] }
  end

  test "should get index for show with sub_comment_id" do
    get sub_comments_url(sub_comment_id: @sub_comment.id), as: :json, headers: auth_header(@user)
    assert_response :success

    assert_pagination
    assert_equal 1, @sub_comment.sub_comments.count
    assert_equal @sub_comment.sub_comments.count, response.parsed_body['results'].count
    assert_equal @sub_comment.sub_comments.map(&:id), response.parsed_body['results'].map { |json| json['id'] }
  end

  test "should return bad request for index when missing id params" do
    get sub_comments_url(), as: :json, headers: auth_header(@user)
    assert_response :bad_request
  end


  test "should create sub_comment for a comment" do
    assert_difference('SubComment.count') do
      post sub_comments_url, params: {
        sub_comment: {
          hashtag: 'hashtag',
          text: "Sub comment",
          comment_id: @comment.id,
          images: ['http://image'],
          videos: ['http://video']
        }
      }, headers: auth_header(@comment.user), as: :json
    end

    assert_response 201
  end

  test "should create sub_comment for a sub_comment" do
    assert_difference('SubComment.count') do
      post sub_comments_url, params: {
        sub_comment: {
          hashtag: 'hashtag',
          text: "Sub comment",
          sub_comment_id: @sub_comment.id,
          images: ['http://image'],
          videos: ['http://video']
        }
      }, headers: auth_header(@sub_comment.user), as: :json
    end

    assert_response 201
  end

  test "should show sub_comment" do
    get sub_comment_url(@sub_comment), as: :json
    assert_response :success
  end

  test "should update sub_comment" do
    patch sub_comment_url(@sub_comment), params: {
      sub_comment: {
        comment_id: @sub_comment.comment_id,
        hashtag: @sub_comment.hashtag,
        text: @sub_comment.text,
        user_id: @sub_comment.user_id
        }
      },
      headers: auth_header(@comment.user), as: :json
    assert_response 200
  end

  test "should destroy sub_comment" do
    # assert_difference('SubComment.count', -1) do
    #   delete sub_comment_url(@sub_comment), as: :json
    # end
    #
    # assert_response 204
  end
end
