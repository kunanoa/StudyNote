class ContainerController < ApplicationController

  # サーバから全てのコンテナIDを取得する。
  def index
    @container = Container.new()
  end

  # 各種コンテナ情報を取得
  # プログラムによる代入の箇所であるため、ストロングパラメータは利用していない。
  def output_container_info(id)
    @container.container_info(id)
  end

  # 起動中であれば停止、停止中であれば起動させる。
  def run
    @container = Container.new(id_params.merge(status_params))
    if @container.valid? && @container.start_stop_container(@container.id, @container.status)
        flash.now[:success] = "処理に成功しました。現在のコンテナのステータスは「#{@container.status}」です。"
    else
      redirect_back(fallback_location: root_path, danger: "処理に失敗しました。現在のコンテナのステータスは「#{@container.status}」です。")
    end
  end

  # コンテナを削除する。
  # status_paramsはバリデーションを通すために渡している。
  def delete
    @container = Container.new(id_params.merge(status_params))
    if @container.valid? && @container.delete_container(@container.id)
      flash.now[:success] = "コンテナの削除に成功しました。"
    else
      redirect_back(fallback_location: root_path, danger: "コンテナの削除に失敗しました。")
    end
  end

  private
  def id_params
    params.permit(:id)
  end

  def status_params
    params.permit(:status)
  end

  helper_method :output_container_info
end

