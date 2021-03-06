class Image < ApplicationRecord

  attr_accessor :id, :repository, :tag, :created, :image_size, :port_host, :port_container

  # バリデーション処理
  validates :id, length: { maximum: 12 }, format: {with: /\A([a-z0-9]+)\z/}, allow_blank: true
  validates :repository, length: { maximum: 15 }, format: {with: /\A([A-Za-z0-9]+[A-Za-z0-9_-]+[A-Za-z0-9]|"<none>")\z/}
  validates :tag, length: { maximum: 12 }, format: {with: /\A([A-Za-z0-9]+[A-Za-z0-9_-]+[A-Za-z0-9]|"<none>")\z/}
  validates :image_size, length: { maximum: 10 }, format: {with: /\A([A-Za-z0-9.]+)\z/}, allow_blank: true
  validates :created, length: { maximum: 22 }, format: {with: /\A([A-Za-z0-9 ]+)\z/}, allow_blank: true
  validates :port_host, length: { in: 1..65535 }, allow_blank: true
  validates :port_container, length: { in: 1..65535 }, allow_blank: true

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
    @port_host = ""
    @port_container = ""
    return @id, @repository, @tag, @created, @image_size ,@port_host ,@port_container
  end

  def create_container(repository, tag, port_host, port_container)
    if port_host != "" && port_container != ""
      `docker run -d -it -p #{port_host}:#{port_container} #{repository}:#{tag}`
      result = true
    elsif port_host != "" || port_container != ""
      result = false
    else
      `docker run -d -it #{repository}:#{tag}`
      result = true
    end
    result
  end

  # 対象イメージを削除する。
  def delete_image(id, repository, tag, image_size, created)
    `docker rmi #{repository}:#{tag}`
    # 削除に成功したかどうかを確認する。（結果はboolean型で返す）
    `sleep 1`
    `(docker images --format "{{.Repository}} {{.Tag}}" | grep "^#{repository} #{tag}$")`.split("\n").size == 0
  end

  def delete_unused_image()
    `docker image prune -f`
    # 削除に成功したかどうかを確認する。（結果はboolean型で返す）
    `sleep 1`
    `(docker images --format "{{.Repository}} {{.Tag}}" | grep "<none>")`.split("\n").size == 0
  end
end