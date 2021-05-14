require 'test_helper'

class CastsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cast = casts(:one)
  end

  test "should get index" do
    get casts_url, as: :json
    assert_response :success
  end

  test "should create cast" do
    assert_difference('Cast.count') do
      post casts_url, params: { cast: { billingOrder: @cast.billingOrder, characterName: @cast.characterName, name: @cast.name, nameId: @cast.nameId, personId: @cast.personId, role: @cast.role, show_id: @cast.show_id } }, as: :json
    end

    assert_response 201
  end

  test "should show cast" do
    get cast_url(@cast), as: :json
    assert_response :success
  end

  test "should update cast" do
    patch cast_url(@cast), params: { cast: { billingOrder: @cast.billingOrder, characterName: @cast.characterName, name: @cast.name, nameId: @cast.nameId, personId: @cast.personId, role: @cast.role, show_id: @cast.show_id } }, as: :json
    assert_response 200
  end

  test "should destroy cast" do
    assert_difference('Cast.count', -1) do
      delete cast_url(@cast), as: :json
    end

    assert_response 204
  end
end
