class Comment < ApplicationRecord
  include AlgoliaSearch
  include Reportable
  include Notifiable

  algoliasearch enqueue: true do
    attributes [:show_title, :short_text, :preview_image, :show_id]
    searchableAttributes [:text, 'unordered(short_text)']
    customRanking ['desc(likes_count)', 'desc(sub_comments_count)', 'desc(shares_count)']
  end

  belongs_to :user, counter_cache: true, optional: true
  belongs_to :show, counter_cache: true, optional: true
  belongs_to :story, counter_cache: true, optional: true
  has_many :likes, dependent: :destroy
  has_many :sub_comments, dependent: :destroy
  has_many :shares, as: :shareable

  def show_title
    show&.title
  end

  def short_text
    text&.truncate(500)
  end

  def preview_image
    images&.first
  end

  def as_json(options = {})
    super(options).merge({ tmsId: show&.tmsId })
  end
end
