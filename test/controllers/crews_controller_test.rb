require 'test_helper'

class CrewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @crew = crews(:one)
  end

  test "should get index" do
    get crews_url, as: :json
    assert_response :success
  end

  test "should create crew" do
    assert_difference('Crew.count') do
      post crews_url, params: { crew: { billingOrder: @crew.billingOrder, name: @crew.name, nameId: @crew.nameId, personId: @crew.personId, role: @crew.role, show_id: @crew.show_id } }, as: :json
    end

    assert_response 201
  end

  test "should show crew" do
    get crew_url(@crew), as: :json
    assert_response :success
  end

  test "should update crew" do
    patch crew_url(@crew), params: { crew: { billingOrder: @crew.billingOrder, name: @crew.name, nameId: @crew.nameId, personId: @crew.personId, role: @crew.role, show_id: @crew.show_id } }, as: :json
    assert_response 200
  end

  test "should destroy crew" do
    assert_difference('Crew.count', -1) do
      delete crew_url(@crew), as: :json
    end

    assert_response 204
  end
end
