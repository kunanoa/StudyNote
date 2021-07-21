class ImagesController < ApplicationController

  # サーバから全てのイメージ情報を取得する。
  def index
    images = Image.new()
    @all_image = images.all_image_info
  end

  def new
    
  end

  # イメージを削除する。
  def delete
    @image = Image.new(image_params)
    if @image.valid? && @image.delete_image(@image.id, @image.repository, @image.tag, @image.image_size , @image.created)
      flash.now[:success] = "イメージの削除に成功しました。"
    else
      redirect_back(fallback_location: root_path, danger: "イメージの削除に失敗しました。")
    end
  end

  def delete_2
    @image = Image.new()
    if @image.delete_unused_image
      redirect_back(fallback_location: root_path, success: "削除可能な不要イメージを削除しました。")
    else
      redirect_back(fallback_location: root_path, danger: "イメージの削除に失敗しました。")
    end
  end

  private
  def image_params
    params.permit(:id, :repository, :tag, :image_size, :created)
  end

end
