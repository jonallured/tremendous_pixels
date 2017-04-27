class TransformTweetJob < ActiveJob::Base
  def perform(target_tweet_id)
    target_tweet = TargetTweet.find_by id: target_tweet_id
    return unless target_tweet
    image = TweetTransformer.transform(target_tweet)
    tweet_image(image)
    ActionCable.server.broadcast 'live', image_src: image.to_src
  end

  private

  def tweet_image(image)
    path = File.join Rails.root, 'tmp', image.to_src
    FileUtils.mkdir_p File.dirname path
    File.binwrite path, image.data
    file = File.new path
    client = TwitterClient.generate
    text = "http://tremendouspixels.com/images/#{image.id}"
    client.update_with_media text, file
  end
end
