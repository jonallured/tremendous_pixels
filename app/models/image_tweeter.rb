class ImageTweeter
  def self.announce(image)
    new(image).announce
  end

  def initialize(image)
    @image = image
  end

  def announce
    client.update_with_media text, file
  end

  private

  def client
    @client ||= TwitterClient.generate
  end

  def text
    "http://tremendouspixels.com/images/#{@image.id}"
  end

  def file
    @file ||= do
      path = File.join Rails.root, 'tmp', @image.to_src
      FileUtils.mkdir_p File.dirname path
      File.binwrite path, @image.data
      File.new path
    end
  end
end
