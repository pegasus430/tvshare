class AdminController < ActionController::Base
  # This is a temporary solution to password-protecting the admin section.
  http_basic_authenticate_with name: "tvchat", password: "tvmatcher", unless: -> { Rails.env.development? }
  layout 'admin'

  def index
  end
end
