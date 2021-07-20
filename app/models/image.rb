class Image < ApplicationRecord

  attr_accessor :id, :repository, :tag, :created, :image_size

  # バリデーション処理
  validates :id, length: { maximum: 12 }, format: {with: /\A([a-z0-9]+|)\z/}, presence: true
  validates :repository, length: { maximum: 15 }, format: {with: /\A([A-Za-z0-9._-]+|)\z/}, presence: true
  validates :tag, length: { maximum: 12 }, format: {with: /\A([A-Za-z0-9._-]+|)\z/}, presence: true
  validates :image_size, length: { maximum: 10 }, format: {with: /\A([A-Za-z0-9.]+|)\z/}, presence: true
  validates :created, length: { maximum: 18 }, format: {with: /\A([A-Za-z0-9 ]+|)\z/}, presence: true

  def all_image_info()
    count = `docker images -q`.chomp.split("\n").count
    all_image = []
    repository_tag = `docker images --format "{{.ID}} {{.Repository}} {{.Tag}} {{.Size}} {{.CreatedSince}}"`.chomp.split("\n")
    repository_tag.each do |repository_tag|
      repository_tag = repository_tag.split(" ")
      id, repository, tag, image_size = repository_tag[0], repository_tag[1], repository_tag[2], repository_tag[3]
      created = repository_tag[4..(repository_tag.size)].join(' ')
      image = Image.new()
      image.image_info(id, repository, tag, image_size, created)
      all_image << image
    end
    all_image
  end

  def image_info(id, repository, tag, image_size, created)
    @id = id
    @repository = repository
    @tag = tag
    @created = created
    @image_size = image_size
    return @id, @repository, @tag, @created, @image_size
  end

  # 対象イメージIDと一致するイメージを削除する。
  def delete_image(id, repository, tag, image_size, created)
    `docker rmi #{repository}:#{tag}`
    # 削除に成功したかどうかを確認する。（結果はboolean型で返す）
    `sleep 1`
    `(docker images --format "{{.Repository}} {{.Tag}}" | grep "^#{repository} #{tag}$")`.split("\n").size == 0
  end

end

  # docker run --name #{name} -d -p #{server-port}:#{container-port} #{repogitory}:#{tag}

  # docker run -d -it ubuntu

  # オプション
  # 「-it --rm」
  # 「-d」…バックグラウンドで実行
  # 「-p」…「ホストマシンのポート：コンテナのポート」でポートフォワード（転送）
  # 「--name」…コンテナに名前をつける
