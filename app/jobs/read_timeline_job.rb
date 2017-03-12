class ReadTimelineJob < ApplicationJob
  def perform
    client = TwitterClient.generate
    timeline_args = {
      trim_user: true,
      # since_id: FewerOnion::Tweet.newest_id,
      include_rts: false,
      exclude_replies: false
    }
    tweets = client.user_timeline(ENV['TARGET_TWITTER'], timeline_args)

    for tweet in tweets
      puts tweet.full_text
    end
  end
end