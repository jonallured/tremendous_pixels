class Image < ApplicationRecord
  belongs_to :target_tweet

  validates_presence_of :data, :palette, :text, :target_tweet

  def self.most_recent
    order('created_at desc').limit(1).first
  end

  def to_src
    "/images/#{id}.png"
  end
end
