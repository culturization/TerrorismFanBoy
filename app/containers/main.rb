# frozen_string_literal: true

module MainContainer
  extend Wrap::Container

  command :ping, desc: 'Pings bot' do
    handler { 'Pong!' }
  end

  def opts_member(act)
    user_id = act.opts['user']&.value

    return nil unless user_id

    Member.find_or_create_by(guild_id: act.guild.id, user_id: user_id)
  end

  def current_member(act)
    user = act.user || act.member.data['user']
    Member.find_or_create_by(guild_id: act.guild.id, user_id: user['id'])
  end
end