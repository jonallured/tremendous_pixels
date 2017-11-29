class TweetTransformer
  def self.transform(target_tweet)
    new(target_tweet).transform
  end

  def initialize(target_tweet)
    @target_tweet = target_tweet
  end

  def transform
    @target_tweet.create_image image_attrs
  end

  private

  def image_attrs
    {
      data: @image_data,
      palette: @image_palette,
      text: @image_text
    }
  end

  def image_data
    @image_data ||= TremendousPNG.as_blob(@image_text, @image_palette)
  end

  def image_palette
    @image_palette ||= TremendousPNG.random_five
  end

  def image_text
    @image_text ||= TremendousPNG.cleaned_text(@target_tweet.full_text)
  end
end
