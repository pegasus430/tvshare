require 'test_helper'

class GetShowImageTest < ActiveSupport::TestCase
  test "Returns preferred image for Series" do
    tmsId = 'SH015226800000'
    assert_equal 'https://wewe.tmsimg.com/assets/p10740531_b1t_h6_aa.jpg', get_image_url(tmsId)
  end

  test "Returns preferred image for Episode (season-level)" do
    tmsId = 'EP015226800052'
    assert_equal 'https://wewe.tmsimg.com/assets/p10740531_b1t_h6_aa.jpg', get_image_url(tmsId)
  end

  test "Returns preferred image for Movie" do
    tmsId = 'MV005521580000'
    assert_equal 'https://wewe.tmsimg.com/assets/p10569481_v_h9_ab.jpg', get_image_url(tmsId)
  end

  private

  def get_image_url(tmsId)
    VCR.use_cassette(tmsId) do
      GetShowImage.new.perform(tmsId)
    end
  end
end
\
