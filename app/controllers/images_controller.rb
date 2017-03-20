class ImagesController < ApplicationController
  expose(:images) { Image.order(:created_at) }
  def show
    image = Image.find_by id: params[:id]
    render body: image.data, content_type: 'image/png'
  end
end
