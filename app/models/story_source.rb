class StorySource < ApplicationRecord
  after_create :verify_iframe_permission
  validates_presence_of :domain
  has_many :stories

  # checks if the domain allows iframe embedding
  def verify_iframe_permission
    story = stories.first
    return true if story&.url&.nil?

    resp = HTTParty.get(story.url)
    if resp.headers['x-frame-options']
      self.iframe_enabled = false
    else
      self.iframe_enabled = true
    end
    self.save
    
  rescue
    # Save the source even if there was an http error.
    true
  end
end
