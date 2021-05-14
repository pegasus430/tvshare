require 'test_helper'

class PreferredImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @preferred_image = preferred_images(:one)
  end

  test "should get index" do
    get preferred_images_url, as: :json
    assert_response :success
  end

  test "should create preferred_image" do
    assert_difference('PreferredImage.count') do
      post preferred_images_url, params: { preferred_image: { category: @preferred_image.category, height: @preferred_image.height, primary: @preferred_image.primary, show_id: @preferred_image.show_id, uri: @preferred_image.uri, width: @preferred_image.width } }, as: :json
    end

    assert_response 201
  end

  test "should show preferred_image" do
    get preferred_image_url(@preferred_image), as: :json
    assert_response :success
  end

  test "should update preferred_image" do
    patch preferred_image_url(@preferred_image), params: { preferred_image: { category: @preferred_image.category, height: @preferred_image.height, primary: @preferred_image.primary, show_id: @preferred_image.show_id, uri: @preferred_image.uri, width: @preferred_image.width } }, as: :json
    assert_response 200
  end

  test "should destroy preferred_image" do
    assert_difference('PreferredImage.count', -1) do
      delete preferred_image_url(@preferred_image), as: :json
    end

    assert_response 204
  end
end
