class ImagesController < ApplicationController
  expose(:images) { Image.order(:created_at) }
  expose :image

  def show
    respond_to do |format|
      format.html
      format.png { render body: image.data, content_type: 'image/png' }
    end
  end
end
