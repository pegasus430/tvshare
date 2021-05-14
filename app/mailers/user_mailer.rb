class UserMailer < ApplicationMailer
  def reset_password
    @user = params[:user]
    @url  = "https://gotvchat.com/reset_password/#{@user.password_reset_token}"
    mail(to: @user.email, subject: 'TV Chat password reset instructions')
  end
end
