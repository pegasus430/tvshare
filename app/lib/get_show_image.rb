# Documentation for Gracnote Image Metadata:
# https://developer.tmsapi.com/page/Image_Metadata

# Image Categories:
#
# Banner – source-provided image, usually shows cast ensemble with source-provided text
# Banner-L1 - same as Banner
# Banner-L2 - source-provided image with plain text
# Banner-L3 - stock photo image with plain text
# Banner-LO - banner with Logo Only

# Image tiers:
#
# Series – image represents of series, regardless of season (banner, iconic, staple, cast, logo)
# Season - image represents specific season of series (banner, iconic, cast, logo)
# Episode - image represents specific episode of series (iconics only)
#

# The following program types currently have images that contain a tier value:
#
# Miniseries
# Series
# Sports

class GetShowImage
  attr_accessor :tmsId, :data

  def perform(tmsId)
    @tmsId = tmsId
    @data = HTTParty.get api_url
    get_preferred_image_url
  end

  def get_preferred_image_url
    image_url = case tmsId.first(2)
    when 'SH'
      get_series_image
    when 'EP'
      # If a season-specific show isn't available, fallback to the series
      get_season_image || get_series_image
    when 'MV'
      get_movie_image
    end

    if image_url.blank?
      Rails.logger.warn("Preferred image not found for #{tmsId}")
      image_url = data.first # fallback to any image
    end

    image_url&.dig('uri')&.gsub('http:', 'https:')
  end

  def get_series_image
    data.find do |image|
      image['size'] == 'Lg' &&
      image['text'] == 'yes' &&
      image['aspect'] == '4x3' &&
      image['tier'] == 'Series' &&
      image['category'] == 'Banner-L1' || image['category'] == 'Banner-L1T'
    end
  end

  def get_season_image
    data.find do |image|
      image['size'] == 'Lg' &&
      image['text'] == 'yes' &&
      image['aspect'] == '4x3' &&
      image['tier'] == 'Season' &&
      image['category'] == 'Banner-L1' || image['category'] == 'Banner-L1T'
    end
  end

  def get_movie_image
    data.find do |image|
      image['size'] == 'Ms' &&
      image['text'] == 'yes' &&
      image['aspect'] == '4x3' &&
      image['category'] == 'VOD Art'
    end
  end

  def api_url
    # Movie do not have the "large" size.
    image_size = tmsId.starts_with?('MV') ? 'Ms' : 'Lg'
    "http://data.tmsapi.com/v1.1/programs/#{tmsId}/images?imageSize=#{image_size}&imageAspectTV=4x3&imageText=true&api_key=#{ENV['TMS_API_KEY']}"
  end
end
