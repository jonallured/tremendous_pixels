require 'securerandom'

class TweetTransformer
  def self.transform(target_tweet)
    new(target_tweet).transform
  end

  def initialize(target_tweet)
    @target_tweet = target_tweet
  end

  def transform
    omg = image_text_data
    lol = colors
    data = image_data(omg, lol)
    @target_tweet.create_image data: data, text: omg.flatten.join, palette: lol
  end

  private

  def image_text_data
    cleaned_tweet_text = @target_tweet.full_text.downcase.gsub(/[^0-9a-z]/, '')
    filler_count = 300 - cleaned_tweet_text.length
    noise = SecureRandom.hex(filler_count)[0...filler_count]
    insert_index = SecureRandom.rand(noise.length)
    full_text = noise.insert(insert_index, cleaned_tweet_text)
    full_text.gsub(/(.{1,15})/, "\\1\n").split("\n").map(&:chars)
  end

  def colors
    names = ChunkyPNG::Color::PREDEFINED_COLORS.keys.sample(5)
    names.map { |name| ChunkyPNG::Color.html_color(name) }
  end

  def image_data(image_text_data, colors)
    pixel_size = 80
    png = ChunkyPNG::Image.new(1200, 1600)

    characters = "abcdefghijklmnopqrstuvwxyz1234567890".chars

    for x in (0...png.width)
      for y in (0...png.height)
        row = (y / pixel_size).to_i
        column = (x / pixel_size).to_i
        character = image_text_data[row][column]

        index = characters.index character
        color = colors[index % colors.count]
        png[x, y] = color
      end
    end

    png.to_blob
  end
end
