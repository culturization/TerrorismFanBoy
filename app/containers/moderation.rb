# frozen_string_literal: true

module Containers
  module Moderation
    extend Wrap::Container

    command :ban, desc: 'Забанить нахуй', perms: (1 << 2).to_s do
      option name: :user, description: 'Цель', type: 6, required: true

      handler do |_bot, act|
        target = act.guild.member(act.opts['user'].value)

        next 'Недостаточно прав' if target.get && !act.member.higher_than?(target)

        target.ban

        'Пользователь успешно забанен'
      end
    end

=begin
    #register_command(
    #  name: 'ban',
    #  description: 'Забанить нахуй',
    #  default_member_permissions: (1 << 2).to_s, # BAN_MEMBERS
    #  options: [{ name: 'user', description: 'Участник', type: 6, required: true }]
    #)

    command 'ban' do |bot, act|
      guild = bot.guild(act.guild.id)
      guild.roles
      target = guild.member(act.command_options['user'].value)

      next 'Недостаточно прав' if target.get && !act.member.higher_than?(target)

      target.ban

      'Пользователь успешно забанен'
    rescue Wrap::Errors::MissingPermissions
      'У бота недостаточно прав'
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
          options: [{ name: 'user', description: 'Участник, чья репутация будет просмотрена', type: 6 }]
        },
        {
          name: 'add', description: 'Увеличить репутацию', type: 1,
          options: [
            { name: 'user', description: 'Участник, чья репутация будет изменена', type: 6, required: true },
            { name: 'value', description: 'Значение, на которое будет увеличена репутация', type: 4, required: true }
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

    handle_command 'rep' do |_bot, act|
      subcommand = act.command_options.first[1]

      target = act.guild.member(subcommand.options['user'].value)

      next 'Такого участника нет на сервере' if target.get.nil?

      target_model = Member.find_or_create_by(guild_id: act.guild.id, user_id: target.user_id)

      case subcommand.name
      when 'show'
        "У <@#{target.user_id}> #{target_model.rep} репутации"
      when 'add', 'set'
        next 'Недостаточно прав' unless act.member.higher_than?(target)

        value = subcommand.options['value'].value

        case subcommand.name
        when 'add' then target_model.rep += value
        when 'set' then target_model.rep = value
        end

        next target_model.errors.full_messages.first unless target_model.save

        'Операция успешно завершена'
      end
    rescue Wrap::Errors::MissingPermissions
      'У бота недостаточно прав'
    rescue Wrap::Errors::OtherError => e
      "Что-то пошло не так: #{e.message}"
    end

=end
  end
end
