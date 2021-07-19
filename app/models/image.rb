class Image < ApplicationRecord

  attr_accessor :id, :repository, :tag, :created, :image_size

  # バリデーション処理
  validates :id, length: { is: 12 }

  def all_image_info()
    ids = `docker images -q`.chomp.split("\n")

    all_image = []
    ids.each do |id|
      image = Image.new()
      image.image_info(id)
      all_image << image
    end
    all_image
  end

  def image_info_command_result(id, element)
    items = `(docker images --format "{{.ID}} {{.#{element}}}" | grep "#{id}")`.split("\n")
    item = items.map do |item|
             item if item.split(" ")[0] == "#{id}"
           end
    item = item.select { |item| item != nil }
    item = item[0].split(" ")
    item = item[1..(item.size)].join(' ')
  end

  def image_info(id)
    element = ["Repository", "Tag", "CreatedSince", "Size"]
    @id = id
    @repository = image_info_command_result(id, element[0])
    @tag = image_info_command_result(id, element[1])
    @created = image_info_command_result(id, element[2])
    @image_size = image_info_command_result(id, element[3])

    return @id, @repository, @tag, @created, @image_size
  end

  # 対象イメージIDと一致するイメージを削除する。
  def delete_image(id)
    image_info(id)
    `docker rmi -f #{id}`

    # 削除に成功したかどうかを確認する。（結果はboolean型で返す）
    `sleep 1`
    `(docker images --format "{{.ID}}" | grep #{id})`.chomp.size == 0
  end

end

  # docker run --name #{name} -d -p #{server-port}:#{container-port} #{repogitory}:#{tag}

  # docker run -d -it ubuntu

  # オプション
  # 「-it --rm」
  # 「-d」…バックグラウンドで実行
  # 「-p」…「ホストマシンのポート：コンテナのポート」でポートフォワード（転送）
  # 「--name」…コンテナに名前をつける
