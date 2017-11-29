class TimelineReader
  def self.read(username)
    new(username).read
  end

  def initialize(username)
    @username = username
  end

  def read
    for tweet in new_tweets
      target_tweet = TargetTweet.create twitter_id: tweet.id, full_text: tweet.full_text
      TransformTweetJob.perform_later(target_tweet.id)
    end
  end

  private

  def client
    @client ||= TwitterClient.generate
  end

  def timeline_args
    args = {
      trim_user: true,
      include_rts: false,
      exclude_replies: false
    }
    args[:since_id] = TargetTweet.newest_id if TargetTweet.any?
    args
  end

  def new_tweets
    tweets = client.user_timeline(@username, timeline_args)
    tweets.reject { |tweet| TargetTweet.exists?(twitter_id: tweet.id) }
  end
end
