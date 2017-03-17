class LiveChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'live'
  end
end
