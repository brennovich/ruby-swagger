module Swagger::Data
  class Mime

    @@types = %w(
      text/plain; charset=utf-8
      application/json
      application/vnd.github+json
      application/vnd.github.v3+json
      application/vnd.github.v3.raw+json
      application/vnd.github.v3.text+json
      application/vnd.github.v3.html+json
      application/vnd.github.v3.full+json
      application/vnd.github.v3.diff
      application/vnd.github.v3.patch'
    )

    def self.valid?(type)
      @@types.include?(type)
    end

  end
end