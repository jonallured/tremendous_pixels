class ReadTimelineJob < ApplicationJob
  READ_DELAY = ENV['READ_DELAY'].to_i.seconds

  def perform
    client = TwitterClient.generate
    timeline_args = {
      trim_user: true,
      include_rts: false,
      exclude_replies: false
    }
    timeline_args[:since_id] = TargetTweet.newest_id if TargetTweet.any?
    tweets = client.user_timeline(ENV['TARGET_TWITTER'], timeline_args)

    for tweet in tweets
      twitter_id = tweet.id
      unless TargetTweet.exists?(twitter_id: twitter_id)
        target_tweet = TargetTweet.create twitter_id: tweet.id, full_text: tweet.full_text
        TransformTweetJob.perform_later(target_tweet.id)
      end
    end

    self.class.set(wait: READ_DELAY).perform_later
  end
end
