require 'grape'
require 'ruby-swagger'

class ErrorRedirectEntity < Grape::Entity
  expose(:errors, documentation: { type: "Array", desc: "errors produced by this method" })
  expose(:message, documentation: { type: "String", desc: "Why? Why? Why????" })
end