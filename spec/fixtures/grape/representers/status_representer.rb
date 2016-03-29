require 'roar/json'

require_relative './image_representer'

class StatusRepresenter
  include Roar::JSON

  property :user_name
  property :text, desc: 'Status update text.'
  property :ip
  property :user_type
  property :user_id

  property :contact_info do
    property :phone
    property :address, type: ImageRepresenter
  end

  property :digest, getter: (lambda do |_options|
    represented.replies.last
  end)

  property :replies, extend: StatusRepresenter, as: :responses
  property :last_reply, extend: StatusRepresenter, getter: (lambda do |_options|
    represented.replies.last
  end)

  collection :list, desc: 'List of elements' do
    nested :option_a do
      property :option_b, type: 'Array', desc: 'An option'
    end

    property :option_c, type: 'Integer', desc: 'Last option'
  end

  property :created_at
  property :updated_at
end
