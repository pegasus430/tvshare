require 'test_helper'

class GuidesControllerTest < ActionDispatch::IntegrationTest
  test "should get live" do
    Timecop.freeze('2021-04-24') do
      VCR.use_cassette('genre_live_guide') do
        get live_guide_url
      end
    end

    assert_response :success
    program = response.parsed_body.first
    assert_equal ["stationId",
      "callSign",
      "affiliateCallSign",
      "affiliateId",
      "videoQuality",
      "preferredImage",
      "airings"], program.keys
    end

    test "should get upcoming" do
      Timecop.freeze('2021-04-24') do
        VCR.use_cassette('genre_live_guide') do
          get upcoming_guide_url
        end
      end

      assert_response :success
      program = response.parsed_body.first
      assert_equal ["stationId",
        "callSign",
        "affiliateCallSign",
        "affiliateId",
        "channel",
        "videoQuality",
        "preferredImage",
        "airings"], program.keys
    end
end
