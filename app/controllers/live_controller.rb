class LiveController < ApplicationController
  expose(:image) { Image.most_recent }

  def show
    layout = params[:layout] || 'application'
    render :show, layout: layout
  end
end
