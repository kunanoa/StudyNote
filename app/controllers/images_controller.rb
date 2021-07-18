class ImagesController < ApplicationController

  # サーバから全てのイメージ情報を取得する。
  def index
    images = Image.new()
    @all_image = images.all_image_info
  end

  # イメージを削除する。
  def delete
    @image = Image.new(id_params)
    if @image.valid? && @image.delete_image(@image.id)
      flash.now[:success] = "イメージの削除に成功しました。"
    else
      redirect_back(fallback_location: root_path, danger: "イメージの削除に失敗しました。")
    end
  end

  private
  def id_params
    params.permit(:id)
  end

end
