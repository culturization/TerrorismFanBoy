# frozen_string_literal: true

module TFB
  class Guild
    def initialize(bot, data)
      @bot = bot
      @id = data['id']
    end

    def ban(user_id)
      @bot.api_call(:put, "guilds/#{@id}/bans/#{user_id}", [:g, @id], {})
    end
  end
end