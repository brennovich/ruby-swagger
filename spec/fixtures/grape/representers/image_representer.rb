require 'roar/json'

class ImageRepresenter
  include Roar::JSON

  property :url, type: String, desc: 'The url of the image'
  property :name, type: String, desc: 'The name of the image'
  property :size, type: Integer, desc: 'Size of the picture'
end
