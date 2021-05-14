class Show < ApplicationRecord
  enum original_streaming_network: { netflix: 0, hulu: 1, prime: 2 }
  acts_as_votable cacheable_strategy: :update_columns
  include AlgoliaSearch

  algoliasearch enqueue: true, id: :tmsId, if: :has_tms_id?, auto_index: false do
    attributes [:title, :episodeTitle, :tmsId, :entityType, :releaseDate,
      :genres, :original_streaming_network, :preferred_image_uri, :cast, :directors,
      :shortDescription, :longDescription, :releaseYear, :seasonNum, :episodeNum]
    searchableAttributes [:title, :episodeTitle, :cast, :directors,
      :original_streaming_network, :releaseYear, 'unordered(longDescription)']
    customRanking ['desc(comments_count)', 'desc(likes_count)', 'desc(stories_count)']
  end

  has_many :comments, dependent: :destroy
  has_many :likes
  has_many :awards, dependent: :destroy
  accepts_nested_attributes_for :awards
  has_many :casts, dependent: :destroy
  accepts_nested_attributes_for :casts
  has_many :crews, dependent: :destroy
  accepts_nested_attributes_for :crews
  has_one :keyword
  accepts_nested_attributes_for :keyword
  has_one :preferred_image, dependent: :destroy
  accepts_nested_attributes_for :preferred_image
  has_one :quality_rating, dependent: :destroy
  accepts_nested_attributes_for :quality_rating
  has_many :ratings, dependent: :destroy
  accepts_nested_attributes_for :ratings
  has_many :recommendations, dependent: :destroy
  accepts_nested_attributes_for :recommendations
  has_and_belongs_to_many :networks
  has_many :stories

  has_many :show_categories
  has_many :categories, through: :show_categories

  validates :tmsId, uniqueness: true, allow_blank: true
  validates :original_streaming_network_id, allow_blank: true,
    uniqueness: { scope: :original_streaming_network }
  validate :is_not_paid_programming

  has_many :shares, as: :shareable

  # TODO: Remove show record from appearing in episode relation.
  has_many :episodes, class_name: 'Show', foreign_key: 'seriesId', primary_key: 'rootId'
  has_one :parent_program, class_name: 'Show', foreign_key: 'rootId', primary_key: 'seriesId'

  scope :originals, -> { where.not(original_streaming_network: nil) }
  scope :with_tms_id, -> { where.not(tmsId: nil) }
  scope :without_tms_id, -> { where(tmsId: nil) }
  scope :parent_shows, -> { where("\"tmsId\" like 'SH%'") }
  scope :non_episode, -> { where.not("\"tmsId\" like 'EP%'") }
  scope :exclude_episodes, -> { where(Show.arel_table[:seriesId].matches Show.arel_table[:rootId]) }

  scope :recent_and_upcoming, -> { where(releaseDate: 7.days.ago..2.days.from_now ) }
  scope :aired_within, -> (range) { where(releaseDate: range ) }
  scope :news_imported_older_than, -> (timeframe) { where("imported_news_at < ?", timeframe.ago).or(Show.where(imported_news_at: nil)) }

  # Checks only the first element in the genre array.
  # Quick solution to prevent duplicates across genres.
  scope :exclude_genre, -> (genre) { where.not("genres @> ARRAY[?]::varchar[]", genre) }
  scope :by_genre, -> (genre) { where("genres @> ARRAY[?]::varchar[]", genre) }
  scope :by_genres, -> (genres) { where("genres && ARRAY[?]::varchar[]", genres) }

  scope :with_episode_title, -> { where.not(episodeTitle: nil) }

  scope :airing_soon, -> { where(origAirDate: 1.week.from_now.to_date ) }
  scope :recently_aired, -> { where(origAirDate: 3.days.ago.to_date ) }

  before_update do
    assign_attributes(networks_count: networks.count, episodes_count: episodes.count)
  end

  def season_and_episode_number
    if episodeNum && seasonNum
      "S#{seasonNum}:E#{episodeNum}"
    end
  end

  def activity_count
    [shares_count, likes_count, comments_count, stories_count].inject(:+) || 0
  end

  # This is used when querying the news-search API
  def news_query
    {
      query_id: news_query_key,
      show_title: title,
      expires: 300
    }
  end

  def news_query_key
    "show-#{id}"
  end

  # used to determine whether it should be indexed by Algolia
  def has_tms_id?
    tmsId.present?
  end

  # Before a show is saved, recalculate its popularity score
  def set_popularity_score
    if tmsId&.start_with?('SH') || tmsId&.start_with?('EP')
      self.popularity_score = calculate_series_popularity_score
    else
      self.popularity_score = calculate_popularity_score
    end
    self.save
  end

  def calculate_popularity_score
    score = 0
    score += stories_count
    score += likes_count
    score += comments_count
    score += awards_count

    # De-prioritize movies and news programs
    score -= 10 if tmsId&.starts_with?('MV')
    score -= 25 if genres&.any? { |genre| genre.include?('News') }
    score
  end

  def self.find_or_import_by_tms_id(tms_id, reimport = false)
    show = Show.find_by(tmsId: tms_id)
    if reimport || show.blank?
      ImportShowJob.perform_now(tmsId: tms_id)
      show = Show.find_by(tmsId: tms_id)
    end
    show
  end

  # show_params: { seriesId: 123 } or { tmsId: 123 } or { rootId: 123 }
  def self.assign_network(show_params, network_id)
    is_orignal_streaming_network =  Show.original_streaming_networks.keys.include?(network_id)
    network = Network.find(network_id) unless is_orignal_streaming_network

    Show.includes(:networks).where(show_params).find_each do |show|
      if is_orignal_streaming_network
        show.original_streaming_network = network_id
      else
        show.networks << network unless show.networks.include?(network)
      end

      show.save
    end
  end

  def networks_and_streaming_services
    _networks = networks.to_a

    streaming_struct = Struct.new(:id, :display_name)
    if original_streaming_network.present?
      _networks.push streaming_struct.new(original_streaming_network, original_streaming_network.titleize)
    end

    _networks
  end

  def formatted_networks
    networks_and_streaming_services.map(&:display_name)
  end

  def calculate_series_popularity_score
    show_count = 0;
    score_total = 0
    award_count = 0 # associated only with parent record

    Show.where(seriesId: seriesId).find_each do |show|
      show_count += 1
      score_total += show.calculate_popularity_score
      if show.tmsId.start_with? 'SH'
        award_count += show.awards_count
      end
    end

    score_total = score_total.to_f / show_count.to_f
    score_total += award_count
    score_total
  rescue ZeroDivisionError
    0
  end

  def rate(user, rating)
    case rating
    when 'love'
      liked_by user, vote_weight: 2, vote_scope: 'love'
    when 'like'
      liked_by user, vote_weight: 1, vote_scope: 'like'
    when 'dislike'
      disliked_by user, vote_weight: 1, vote_scope: 'dislike'
    end

    update_rating_cache
  end

  def is_show?
    tmsId&.starts_with?('SH')
  end

  def is_episode?
    tmsId&.starts_with?('EP')
  end

  def is_movie?
    tmsId&.starts_with?('MV')
  end

  private

  def update_rating_cache
    vote_tallies = votes_for.group(:vote_scope).count
    total_votes = vote_tallies.sum { |k, v| v }.to_f

    tally_and_round = -> (scope) do
      percentage = (vote_tallies[scope] || 0) / total_votes
      (percentage * 100).round(2)
    end

    self.rating_percentage_cache = {
      'love': tally_and_round.call('love'),
      'like': tally_and_round.call('like'),
      'dislike': tally_and_round.call('dislike'),
    }
    self.save
  end

  def is_not_paid_programming
    if subType == 'Paid Programming'
      errors.add(:subType, "can't be Paid Programming")
    end
  end
end
