# frozen_string_literal: true

module TFB
  class Message
    attr_reader :id, :content, :channel, :author

    def initialize(bot, data)
      @bot = bot
      @id = data['id']
      @content = data['content']
      @channel = TFB::Channel.new(bot, 'id' => data['channel_id'])
      @author = data['author'] # make user object
    end

    def reply(content)
      @channel.send_message(content)
    end
  end
end