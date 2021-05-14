class GoogleAuthVerification
  def self.verify(id_token)
    raise 'GOOGLE_AUTH_CLIENT_ID must be set' if ENV['GOOGLE_AUTH_CLIENT_ID'].blank?

    verification_url = "https://oauth2.googleapis.com/tokeninfo?id_token=#{id_token}"
    result = HTTParty.get(verification_url)
    if result['aud'] == ENV['GOOGLE_AUTH_CLIENT_ID']
      result
    else
      raise 'Google ID Token cannot be verified'
    end
  end
end
