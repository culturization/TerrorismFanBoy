# frozen_string_literal: true

module TFB
  class DiscordError < RuntimeError
    attr_reader :http_code, :code, :message

    def initialize(res)
      @http_code = res.code
      json = JSON.parse(res.body)
      @code = json['code']
      @message = json['message']
    end
  end
end