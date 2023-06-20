# frozen_string_literal: true

module Containers
  module Levels
    extend Wrap::Container

=begin
    command 'xp' do |_bot, act|
      case (group = act.command_options.first[1]).name
      when 'multiplier'
        guild_model = Guild.find_by_guild_id(act.guild.id)

        case group.options.first[1]
        when 'set'
          guild_model.multiplier = group['multiplier'].value

          next guild_model.errors.full_messages unless guild_model.save

          'Множитель опыта сохранен'
        when 'view'
          "Множитель опыта: #{guild_model.multiplier}"
        end
      when 'view', 'set', 'add'
        member_model = Member.find_or_create_by(guild_id: act.guild.id, user_id: group['user'])

        case group.name
        when 'view' then "Опыт участника <@#{member_model.user_id}>: #{member_model.xp}"
        when 'set', 'add'
          group.name == 'set' ? member_model.xp = group['xp'] : member_model.xp += group['xp']

          next member_model.errors.full_messages unless member_model.save

          'Операция прошла успешно'
        end
      end
    end
=end

    event 'MESSAGE_CREATE' do |_bot, _data|
      @last_xp_msgs ||= {}

      guild_model = Guild.find_by_guild_id(act.guild.id)
      member_params = { guild_id: act.guild.id, user_id: act.user_id }
      member_model = Member.find_by(member_params)

      next Member.create(member_params) if member_model.nil? # create member model and return

      time = @last_xp_msgs[member_model.id]

      next if time && Time.now - time < 60 # minute should pass

      @last_xp_msgs[member_model.id] = Time.now
      member_model.xp += rand(1..5) * guild_model.multiplier

      # TODO: level roles
    end
  end
end
