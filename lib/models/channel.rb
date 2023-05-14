# frozen_string_literal: true

module TFB
  class Channel
    attr_reader :id, :type, :guild, :name, :topic, :nsfw

    def initialize(bot, data)
      @bot = bot
      @id = data['id']
    end

    def send_message(content)
      @bot.api_call(:post, "channels/#{@id}/messages", [:c, @id], content: content)
    end

    def get
      data = @bot.api_call(:get, "channels/#{@id}", [:c, @id])
      
      @type = data['type']
      @guild = @bot.guild(data['guild_id'])
      @name = data['name']
      @topic = data['topic']
      @nsfw = data['nsfw']
    end
  end
end