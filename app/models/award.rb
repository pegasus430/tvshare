class Award < ApplicationRecord
  belongs_to :show, counter_cache: true
end
