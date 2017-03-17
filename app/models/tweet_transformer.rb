require 'securerandom'

class ColorSet
  attr_reader :hue, :saturation, :lightness

  def self.compute_for(hue, saturation, lightness)
    new(hue, saturation, lightness).compute
  end

  def initialize(hue, saturation, lightness)
    @hue = hue
    @saturation = saturation
    @lightness = lightness
  end

  def compute
    raise 'Implement in subclass'
  end

  private

  def initial_color
    ChunkyPNG::Color.from_hsl(hue, saturation, lightness)
  end

  def saturation
    1.0
  end

  def lightness
    0.5
  end

  def adjust_hue_by(degrees)
    ending_hue = hue + degrees
    ending_hue = ending_hue + 360 if ending_hue < 0
    ending_hue = ending_hue - 360 if ending_hue > 360
    ending_hue
  end
end

class AnalogousColors < ColorSet
  def compute
    [
      lower_analogous_color,
      initial_color,
      higher_analogous_color
    ]
  end

  private

  def lower_analogous_color
    lower_hue = adjust_hue_by(-30)
    lower_analogous_color = ChunkyPNG::Color.from_hsl(lower_hue, saturation, lightness)
  end

  def higher_analogous_color
    higher_hue = adjust_hue_by(+30)
    higher_analogous_color = ChunkyPNG::Color.from_hsl(higher_hue, saturation, lightness)
  end
end

class ComplementaryColors < ColorSet
  def compute
    [
      initial_color,
      complementary_color
    ]
  end

  private

  def complementary_color
    complementary_hue = adjust_hue_by(+180)
    ChunkyPNG::Color.from_hsl(complementary_hue, saturation, lightness)
  end
end

class TriadicColors < ColorSet
  def compute
    [
      lower_triadic_color,
      initial_color,
      higher_triadic_color
    ]
  end

  private

  def lower_triadic_color
    lower_hue = adjust_hue_by(-120)
    puts "lower_hue: #{lower_hue}"
    ChunkyPNG::Color.from_hsl(lower_hue, saturation, lightness)
  end

  def higher_triadic_color
    higher_hue = adjust_hue_by(+120)
    puts "higher_hue: #{higher_hue}"
    ChunkyPNG::Color.from_hsl(higher_hue, saturation, lightness)
  end
end

class TweetTransformer
  def self.transform(target_tweet)
    new(target_tweet).transform
  end

  def initialize(target_tweet)
    @target_tweet = target_tweet
  end

  def transform
    # get the text of the tweet
    # add noise to arrive at the text for the image
    # pick a palette
    # create the image data
    omg = image_text_data
    lol = colors
    data = image_data(omg, lol)
    # save the Image model
    @target_tweet.create_image data: data, text: omg, palette: lol
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
    hue = SecureRandom.rand(360)
    saturation = (SecureRandom.rand(10) + 91) / 100.0
    lightness = (SecureRandom.rand(20) + 41) / 100.0

    color_sets = [
      AnalogousColors,
      ComplementaryColors,
      TriadicColors
    ]

    color_set = color_sets[SecureRandom.rand(color_sets.count)]
    color_set.compute_for(hue, saturation, lightness)
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

    # png.save('omg.png')
    png.to_blob
  end
end
