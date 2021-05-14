class AuthenticationController < ApplicationController
  before_action :authorize_request, except: [:login, :login_social]

  def login
    if login_params[:username]&.include?('@')
      @user = User.find_by(email: login_params[:username])
    else
      @user = User.find_by(username: login_params[:username])
    end

    if @user.present? && @user.authenticate(login_params[:password]) #authenticate method provided by Bcrypt and 'has_secure_password'
      token = encode(user_id: @user.id, username: @user.username)
      render json: { token: token , user: @user}, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def login_social
    if params[:google_token]
      social_data = GoogleAuthVerification.verify(params[:google_token])
      google_id = social_data.dig('sub')
      @user = User.find_or_initialize_by(google_id: google_id)

      unless @user.persisted?
        @user.email = social_data.dig('email')
        @user.image = social_data.dig('picture')
        @user.username = social_data.dig('email')&.split('@')&.first
        @user.password = SecureRandom.gen_random(64) # random password
        @user.save
      end
    end

    if params[:facebook_token]
      social_data = HTTParty.get("https://graph.facebook.com/v8.0/#{params[:facebook_id]}?fields=email,name,picture&access_token=#{params[:facebook_token]}")
      facebook_id = social_data.dig('id')
      @user = User.find_or_initialize_by(facebook_id: facebook_id)

      unless @user.persisted?
        @user.email = social_data.dig('email')
        @user.image = social_data.dig('picture', 'data', 'url')
        @user.username = social_data.dig('email')&.split('@')&.first
        @user.password = SecureRandom.gen_random(64) # random password
        @user.save
      end
    end

    if @user && @user.persisted?
      token = encode(user_id: @user.id, username: @user.username)
      render json: { token: token , user: @user}, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def verify
    render json: @current_user
  end

  private

  def login_params
    params.permit(:username, :password)
  end
end
