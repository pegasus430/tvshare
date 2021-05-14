require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comment = comments(:one)
    @story = stories(:one)
    @show = shows(:one)
    @user = @comment.user
  end

  test "should get index for show with tmsId" do
    get comments_url(tmsId: @show.tmsId), as: :json, headers: auth_header(@user)
    assert_response :success
    assert_pagination

    assert_equal @show.comments.map(&:id), response.parsed_body['results'].map { |json| json['id'] }
    assert_equal @show.comments.count, response.parsed_body['results'].count
  end

  test "should get index for show with tms_id" do
    get comments_url(tms_id: @show.tmsId), as: :json, headers: auth_header(@user)
    assert_response :success
    assert_pagination
    assert_equal @show.comments.map(&:id), response.parsed_body['results'].map { |json| json['id'] }
    assert_equal @show.comments.count, response.parsed_body['results'].count
  end

  test "should get index for show with show_id" do
    get comments_url(show_id: @show.id), as: :json, headers: auth_header(@user)
    assert_response :success
    assert_pagination
    assert_equal @show.comments.map(&:id), response.parsed_body['results'].map { |json| json['id'] }
    assert_equal @show.comments.count, response.parsed_body['results'].count
  end

  test "should get index for story" do
    get comments_url(story_id: @story.id), as: :json, headers: auth_header(@user)
    assert_response :success
    assert_pagination
    assert_equal @story.comments.map(&:id), response.parsed_body['results'].map { |json| json['id'] }
    assert_equal 1, response.parsed_body['results'].count
  end

  test "should create comment for a show" do
    assert_difference('Comment.count') do
      post comments_url, params: {
        comment: {
          hashtag: 'hashtag',
          text: "comment",
          show_id: @show.id,
          images: ['http://image'],
          videos: ['http://video']
        }
      }, as: :json, headers: auth_header(@user)
    end
    assert_response 200
  end

  test "should create comment for a story" do
    assert_difference('Comment.count') do
      post comments_url, params: {
        comment: {
          hashtag: 'hashtag',
          text: "comment",
          story_id: @story.id,
          images: ['http://image'],
          videos: ['http://video']
        }
      },as: :json, headers: auth_header(@user)
    end

    assert_response 200
  end

  test "should show comment" do
    get comment_url(@comment), as: :json, headers: auth_header(@user)
    assert_response :success
  end

  test "should update comment" do
    patch comment_url(@comment), params: { comment: { hashtag: @comment.hashtag, text: @comment.text, user_id: @comment.user_id } }, as: :json, headers: auth_header(@user)
    assert_response 200
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      delete comment_url(@comment), as: :json, headers: auth_header(@user)
    end

    assert_response 204
  end
end
