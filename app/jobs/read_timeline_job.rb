class ReadTimelineJob < ApplicationJob
  READ_DELAY = ENV['READ_DELAY'].to_i.seconds

  def perform
    TimelineReader.read(ENV['TARGET_TWITTER'])
    self.class.set(wait: READ_DELAY).perform_later
  end
end
