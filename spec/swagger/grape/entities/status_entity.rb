require 'grape'
require 'grape-entity'

class Status < Grape::Entity
  format_with(:iso_timestamp) { |dt| dt.iso8601 }

  expose :user_name
  expose :text, documentation: { type: "String", desc: "Status update text." }
  expose :ip, if: { type: :full }
  expose :user_type, :user_id, if: lambda { |status, options| status.user.public? }
  expose :contact_info do
    expose :phone
    expose :address, using: ImageEntity
  end
  expose :digest do |status, options|
    Digest::MD5.hexdigest status.txt
  end
  expose :replies, using: Status, as: :responses

  expose :last_reply, using: Status do |status, options|
    status.replies.last
  end

  with_options(format_with: :iso_timestamp) do
    expose :created_at
    expose :updated_at
  end
end
