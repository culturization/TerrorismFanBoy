# frozen_string_literal: true

module TFB
  module Container
    def on_event(event, &block)
      @event_handlers ||= {}
      @event_handlers[event] = block
    end
  
    def command(cmd, &block)
      @command_handlers ||= {}
      @command_handlers[cmd] = block
    end
  end
end