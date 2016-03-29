require 'grape-entity'
require_relative './image_entity'

class StatusEntity < Grape::Entity
  format_with(:iso_timestamp, &:iso8601)

  expose :user_name
  expose :text, documentation: { type: 'String', desc: 'Status update text.' }
  expose :ip, if: { type: :full }
  expose :user_type, :user_id, if: ->(status, _options) { status.user.public? }
  expose :contact_info do
    expose :phone
    expose :address, using: ImageEntity
  end
  expose :digest do |status, _options|
    Digest::MD5.hexdigest status.txt
  end
  expose :replies, using: StatusEntity, as: :responses

  expose :last_reply, using: StatusEntity do |status, _options|
    status.replies.last
  end

  expose :list, documentation: { type: 'Array', desc: 'List of elements' } do
    expose :option_a do
      expose :option_b, documentation: { type: 'Array', desc: 'An option' }
    end

    expose :option_c, documentation: { type: 'Integer', desc: 'Last option' }
  end

  with_options(format_with: :iso_timestamp) do
    expose :created_at
    expose :updated_at
  end
end
