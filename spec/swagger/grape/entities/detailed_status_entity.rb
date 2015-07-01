require 'grape'
require 'grape-entity'
require_relative './status_entity'

class StatusDetailed < API::Entities::Status
  expose :internal_id
end