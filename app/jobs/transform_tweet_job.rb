class TransformTweetJob < ActiveJob::Base
  def perform(target_tweet_id)
    target_tweet = TargetTweet.find_by id: target_tweet_id
    return unless target_tweet
    image = TweetTransformer.transform(target_tweet)
    ImageTweeter.announce(image)
    ActionCable.server.broadcast 'live', image_src: image.to_src
  end
end
