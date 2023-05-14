# frozen_string_literal: true

module TFB
  module ModerationContainer
    extend TFB::Container

    command('ban') do |bot, msg, params|
      channel = msg.channel
      channel.get
      channel.guild.ban(params.first)
      msg.reply('Пользователь успешно забанен')
    rescue TFB::DiscordError => e
      msg.reply("Что-то пошло не так: #{e.message}")
    end
  end
end