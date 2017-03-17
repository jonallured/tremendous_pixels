class TransformTweetJob < ActiveJob::Base
  def perform(target_tweet_id)
    target_tweet = TargetTweet.find_by id: target_tweet_id
    return unless target_tweet
    TweetTransformer.transform(target_tweet)
    ActionCable.server.broadcast 'live', image_src: Image.most_recent.to_src
  end
end
