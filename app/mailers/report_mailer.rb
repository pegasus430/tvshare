class ReportMailer < ApplicationMailer
  INTERNAL_EMAIL = 'tvchathq@gmail.com'

  def report_content
    @report = params[:report]
    @user = @report.user

    mail(to: INTERNAL_EMAIL, subject: "User #{@user.id} has reported content")
  end
end
