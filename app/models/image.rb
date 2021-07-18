class Image < ApplicationRecord

  attr_accessor :id, :repository, :tag, :created, :size

  def all_image_info()
    ids = `docker images -q`.chomp!.split("\n")

    all_image = []
    ids.each do |id|
      image = Image.new()
      image.image_info(id)
      all_image << image
    end
    all_image
  end

  def image_info(id)
    @id = id
    @repository = `(docker images --format "{{.ID}} {{.Repository}}" | grep "#{id}")`.split(" ")[1]
    @tag = `(docker images --format "{{.ID}} {{.Tag}}" | grep "#{id}")`.split(" ")[1]
    @created = `(docker images --format "{{.ID}} {{.CreatedSince}}" | grep "#{id}")`.split(" ")[1]
    @size = `(docker images --format "{{.ID}} {{.Size}}" | grep "#{id}")`.split(" ")[1]

    return @id, @repository, @tag, @created, @size
  end

end
