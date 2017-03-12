class ReadTimelineJob < ApplicationJob
  READ_DELAY = ENV['READ_DELAY'].to_i.seconds

  def perform
    client = TwitterClient.generate
    timeline_args = {
      trim_user: true,
      since_id: TargetTweet.newest_id,
      include_rts: false,
      exclude_replies: false
    }
    tweets = client.user_timeline(ENV['TARGET_TWITTER'], timeline_args)

    for tweet in tweets
      twitter_id = tweet.id
      unless TargetTweet.exists?(twitter_id: twitter_id)
        TargetTweet.create twitter_id: tweet.id, full_text: tweet.full_text
      end
    end

    self.class.set(wait: READ_DELAY).perform_later
  end
end
