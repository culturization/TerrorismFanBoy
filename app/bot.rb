#/usr/bin/env ruby

class TFB
  include Wrap::Bot

  def initialize(...)
    @intents = 33280
    super(...)
    include_containers(Commands::Misc, Commands::Moderation)
  end

  def wrap_msg(resp)
    { type: 4, data: { content: resp } }
  end
end