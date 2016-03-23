require 'grape-entity'

require_relative './image_entity'

class ApplicationEntity < Grape::Entity
  expose(:id, documentation: { type: 'String', desc: 'unique ID' })
  expose(:name, documentation: { type: 'String', desc: 'Human readable application name' })
  expose(:description, documentation: { type: String, desc: 'Application description' })
  expose(:free, documentation: { type: 'Boolean', desc: 'True if application is free' })
  expose :application_pictures, using: ImageEntity, as: :pictures, documentation: { type: Array, desc: 'Application pictures' }
end
