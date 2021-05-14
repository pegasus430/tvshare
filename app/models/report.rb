class Report < ApplicationRecord
  belongs_to :user
  belongs_to :reportable, polymorphic: true
  before_validation :normalize_reportable_type
  after_create :notify_admin

  def notify_admin
    ReportMailer.with(report: self).report_content.deliver_now
  rescue => e
    puts "There was an email sending the report content email"
    puts e.backtrace
  end

  private

  # In case the API doens't send properly capitalized params
  def normalize_reportable_type
    self.reportable_type = self.reportable_type.camelize
  end
end
