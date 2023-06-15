# frozen_string_literal: true

module Commands
  module Moderation
    extend Wrap::Container

    register_command(
      name: 'ban',
      description: 'Забанить нахуй',
      default_member_permissions: (1 << 2).to_s, # BAN_MEMBERS
      options: [ { name: 'user', description: 'Участник', type: 6, required: true } ]
    )

    handle_command 'ban' do |bot, act|
      guild = bot.guild(act.guild.id)
      roles = guild.roles
      target = guild.member(act.command_options['user'].value)

      begin
        target.get
      rescue Wrap::Errors::UnknownMember
      else
        next 'У вас слишком низкая роль' unless act.member.higher_than?(target)
      end

      target.ban

      'Пользователь успешно забанен'
    rescue Wrap::Errors::MissingPermissions
      'Недостаточно прав'
    rescue Wrap::Errors::OtherError => e
      "Что-то пошло не так: #{e.message}"
    end

    register_command(
      name: 'rep',
      description: 'Операции с репутацией пользователей',
      default_member_permissions: (1 << 3).to_s, # ADMINISTRATOR
      options: [
        {
          name: 'show', description: 'Посмотреть репутацию', type: 1,
          options: [ { name: 'user', description: 'Участник, чья репутация будет просмотрена', type: 6 } ]
        },
        {
          name: 'add', description: 'Увеличить репутацию', type: 1,
          options: [
            { name: 'user', description: 'Участник, чья репутация будет изменена', type: 6, required: true},
            { name: 'value', description: 'Значение, на которое будет увеличена репутация', type: 4, required: true}
          ]
        },
        {
          name: 'set',
          description: 'Изменить значение репутации',
          type: 1,
          options: [
            { name: 'user', description: 'Участник, чья репутация будет изменена', type: 6, required: true },
            { name: 'value', description: 'Новое значение репутации', type: 4, required: true }
          ]
        }
      ]
    )

    handle_command 'rep' do |bot, data|
      guild = bot.guild(data['guild_id'])
      member = guild.member(nil, data['member'])
      options = CommandOptions.new(data.dig('data', 'options', 0, 'options'))

      case data.dig('data', 'options', 0, 'name')
      when 'show'
        target_id = options['user'] || member.user_id

        rep = bot.db.execute(<<~EOQ, [target_id, guild.id])[0]
        select rep from members
        where uid = ? and guild_id = ?
        EOQ
        "У <@#{target_id}> #{rep || 0} репутации"
      when 'add'
        target = guild.member(options['user'])
        target.get
          
        next 'Ты не можете изменять репутацию участника выше тебя' unless member.higher_than?(target)

        bot.db.execute(<<~EOQ, [target.user_id, guild.id, options['value']])
        update members
        where uid = ? and guild_id = ?
        set rep = rep + ?
        EOQ
        'Репутация пользователя успешно изменена'
      when 'set'
        target = guild.member(options['user'])
        target.get

        next 'Ты не можете изменять репутацию участника выше тебя' unless member.higher_than?(target)

        bot.db.execute(<<~EOQ, [target.user_id, guild.id, options['value']])
        update members
        where uid = ? and guild_id = ?
        set rep = ?
        EOQ
        'Репутация пользователя успешно изменена'
      end
    rescue Errors::UnknownMember
      'Такого пользователя нету на сервере'
    rescue Errors::MissingPermissions
      'Недостаточно прав'
    rescue Errors::OtherError => e
      "Что-то пошло не так: #{e.message}"
    end
  end
end