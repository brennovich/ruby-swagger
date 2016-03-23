require 'grape-entity'

class ImageEntity < Grape::Entity
  expose(:url, documentation: { type: String, desc: 'The url of the image' })
  expose(:name, documentation: { type: String, desc: 'The name of the image' })
  expose(:size, documentation: { type: Integer, desc: 'Size of the picture' })
end
