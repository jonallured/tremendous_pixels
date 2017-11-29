require 'securerandom'

class TremendousPNG
  ROWS = 20
  COLS = 15

  def self.cleaned_text(raw_text)
    cleaned_text = raw_text.downcase.gsub(/[^0-9a-z]/, '')

    max_length = ROWS * COLS

    full_text = if cleaned_text.size > max_length
                  cleaned_text.first(max_length)
                else
                  count = max_length - cleaned_text.length
                  noise = SecureRandom.hex(count)[0...count]
                  index = SecureRandom.rand(noise.length)
                  noise.insert(index, cleaned_text)
                end

    full_text.gsub(/(.{1,#{COLS}})/, "\\1\n").split("\n").map(&:chars)
  end

  def self.random_five
    names = ChunkyPNG::Color::PREDEFINED_COLORS.keys.sample(5)
    names.map { |name| ChunkyPNG::Color.html_color(name) }
  end

  def self.as_blob(text, palette)
    pixel_size = 80
    characters = "abcdefghijklmnopqrstuvwxyz1234567890".chars

    png = ChunkyPNG::Image.new(1200, 1600)

    for x in (0...png.width)
      for y in (0...png.height)
        row = (y / pixel_size).to_i
        column = (x / pixel_size).to_i
        character = text[row][column]

        index = characters.index character
        color = palette[index % palette.count]
        png[x, y] = color
      end
    end

    png.to_blob
  end
end
