require 'grape-entity'

class ErrorRedirectEntity < Grape::Entity
  expose(:errors, documentation: { type: 'Array', desc: 'errors produced by this method' })
  expose(:message, documentation: { type: 'String', desc: 'Why? Why? Why????' })
end

class ErrorNotFoundEntity < ErrorRedirectEntity; end
class ErrorBoomEntity < ErrorRedirectEntity; end
