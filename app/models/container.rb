class Container < ApplicationRecord

  attr_accessor :id, :name, :status, :port, :image

  # バリデーション処理
  validates :id, length: { is: 12 }
  validates :status, format: { with: /(稼働中|停止)/ }
  
  def self.all_container_ids()
    `docker ps -a --format "{{.ID}}"`.split("\n")
  end

  def container_info(id)
    @id = id
    @name = `docker ps -af "id=#{id}" --format '{{.Names}}'`.chomp!
    @status = `docker ps -af "id=#{id}" --format '{{.Status}}'`.chomp!
    @port = `docker ps -af "id=#{id}" --format '{{.Ports}}'`.chomp!
    @image = `docker ps -af "id=#{id}" --format '{{.Image}}'`.chomp!

    if @status.include?("Up")
      @status = "稼働中"
    else
      @status = "停止"
    end

    return @id, @name, @status, @port, @image
  end

  # 対象コンテナのステータス情報から、コンテナが起動中か停止中かを判別し、起動/停止させる。
  def start_stop_container(id, status)
    before_status = status
    if status.include?("稼働中")
      `docker container stop #{id}`
    else
      `docker container start #{id}`
    end

    # 1秒待って、ステータスが変化しているか確認する。（結果はboolean型で返す）
    `sleep 1`
    container_info(id)
    @status != before_status
  end

  # 対象コンテナIDと一致するコンテナを削除する。
  def delete_container(id)
    container_info(id)
    `docker rm -f #{id}`

    # 削除に成功したかどうかを確認する。（結果はboolean型で返す）
    `sleep 1`
    `docker ps -aqf "id=#{id}"`.chomp.size == 0
  end  
  
end
