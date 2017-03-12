class TargetTweet < ApplicationRecord
  validates_presence_of :twitter_id, :full_text
  validates_uniqueness_of :twitter_id

  def self.newest_id
    order('created_at').pluck(:twitter_id).last
  end
end
