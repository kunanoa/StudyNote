class Image < ApplicationRecord

  attr_accessor :id, :repository, :tag, :created, :image_size

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

    repository = `(docker images --format "{{.ID}} {{.Repository}}" | grep "#{id}")`.split(" ")
    tag = `(docker images --format "{{.ID}} {{.Tag}}" | grep "#{id}")`.split(" ")
    created = `(docker images --format "{{.ID}} {{.CreatedSince}}" | grep "#{id}")`.split(" ")
    image_size = `(docker images --format "{{.ID}} {{.Size}}" | grep "#{id}")`.split(" ")

    @id = id
    @repository = repository[1..(repository.size)].join(' ')
    @tag = tag[1..(tag.size)].join(' ')
    @created = created[1..(created.size)].join(' ')
    @image_size = image_size[1..(image_size.size)].join(' ')

    return @id, @repository, @tag, @created, @image_size
  end

end
