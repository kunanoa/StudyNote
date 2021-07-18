class ImagesController < ApplicationController

  # サーバから全てのイメージ情報を取得する。
  def index
    images = Image.new()
    @all_image = images.all_image_info
  end

end
