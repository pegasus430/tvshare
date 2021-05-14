class ShowCategory < ApplicationRecord
  belongs_to :show
  belongs_to :category
  default_scope { order(position: :asc) }
end
