# frozen_string_literal: true

module MainContainer
  extend Wrap::Container

  command :ping, desc: 'Pings bot' do
    handler { 'Pong!' }
  end

  command :info, desc: 'Информация' do
    subcommand name: :user, desc: 'об участнике' do
      option name: :user, description: 'Участник, информацию о котором нужно узнать', type: 6
      
      handler do
        member = opts_member || current_member

        <<~EOT
        Репутация: #{member.rep}
        Опыт: #{member.xp}
        EOT
      end
    end

    subcommand name: :guild, desc: 'о сервере' do
      handler do
        <<~EOT
        Множитель опыта: #{current_guild.xp_multiplier}
        EOT
      end
    end
  end

  def opts_member
    user_id = ctx.opts['user']&.value

    return nil unless user_id

    Member.find_or_create_by(guild_id: act.guild.id, user_id: user_id)
  end

  def current_member
    @current_member ||= Member.find_or_create_by(
      guild_id: ctx.data['guild']['id'],
      user_id: (ctx.data['user'] || ctx.data['member']['user'])['id']
    )
  end

  def current_guild
    @current_guild ||= Guild.find_or_create_by(guild_id: ctx.data['guild']['id'])
  end
end