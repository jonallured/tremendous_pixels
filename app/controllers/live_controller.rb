class LiveController < ApplicationController
  expose(:image) { Image.most_recent }
end
