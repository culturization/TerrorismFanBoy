# frozen_string_literal: true

# /usr/bin/env ruby

class TFB
  include Wrap::Bot

  def initialize(...)
    @intents = 33_280
    super(...)
    include_containers(Containers::Misc, Containers::Moderation)
  end

  def wrap_msg(resp)
    { type: 4, data: { content: resp } }
  end
end
