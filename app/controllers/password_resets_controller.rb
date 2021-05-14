class PasswordResetsController < ApplicationController
  def generate
    user = User.find_by!(email: params.require(:email))
    head(:ok) if user.generate_reset_password_token
  rescue ActiveRecord::RecordNotFound
    head(:not_found)
  end

  def exists
    if User.exists?(email: params.require(:email))
      head(:ok)
    else
      head(:not_found)
    end
  end

  def save
    token = params.require(:token)
    password = params.require(:password)
    password_confirmation = params.require(:password_confirmation)
    head(:ok) if User.reset_password(token, password, password_confirmation)
  rescue ActiveRecord::RecordNotFound
    head(:not_found)
  end
end
