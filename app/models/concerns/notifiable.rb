module Notifiable
  extend ActiveSupport::Concern
  attr_accessor :action

  included do
    has_many :notifications, as: :notifiable
  end
end
