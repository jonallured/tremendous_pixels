class ImagesController < ApplicationController
  expose(:images) { Image.order(:created_at) }
  expose(:image) { Image.find_by id: params[:id] }

  def show
    respond_to do |format|
      format.html
      format.png { render body: image.data, content_type: 'image/png' }
    end
  end
end
