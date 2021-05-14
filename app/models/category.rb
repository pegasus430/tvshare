class Category < ApplicationRecord
  has_many :show_categories
  has_many :shows, through: :show_categories
end
