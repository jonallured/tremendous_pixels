class HomeController < ApplicationController
  expose(:image) { Image.order('created_at DESC').limit(1).first }
end
