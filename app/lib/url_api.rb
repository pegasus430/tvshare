class UrlApi
  include HTTParty
  def self.fetch start_date, end_date, networks
    api_url = "https://data.tmsapi.com/v1.1/lineups/USA-HULU501-DEFAULT/grid?startDateTime=#{start_date}&endDateTime=#{end_date}&stationId=#{networks.map{|network| network[:stationId]}}&imageAspectTV=4x3&imageSize=Lg&api_key=v5nfdpmz66hp2nd5t9gefcrc"
    resp = HTTParty.get(api_url)
    byebug
    data = resp.body
  end
end