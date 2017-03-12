class TargetTweet < ApplicationRecord
  validates_presence_of :twitter_id, :full_text
  validates_uniqueness_of :twitter_id
end
