# frozen_string_literal: true

module ModContainer
  extend Wrap::Container

  command :ban, desc: 'Забанить нахуй', perms: (1 << 2).to_s do
    option name: :user, description: 'Цель', type: 6, required: true
    option name: :reason, description: 'Причина бана', type: 3

    handler do
      target = ctx.guild.member(ctx.opts['user'].value)

      next 'Недостаточно прав' if target.get && !ctx.member.higher_than?(target)

      target.ban(reason: ctx.opts['reason']&.value)

      'Пользователь успешно забанен'
    end
  end

  command :rep, desc: 'Операции с репутацией', perms: (1 << 3).to_s do
    subcommand name: :add, desc: 'Прибавить к репутации пользователя определенное значение' do
      option name: :user, description: 'Участник, чья репутация будет изменена', type: 6, required: true
      option name: :num, description: 'Значение, которое будет прибавлено к репутации', type: 4, required: true

      handler do
        opts_member.rep += ctx.opts['num'].value

        next opts_member.errors.full_messages.first unless opts_member.save

        "Операция прошла успешно, теперь у <@#{opts_member.user_id}> #{opts_member.rep} опыта"
      end
    end

    subcommand name: :set, desc: 'Изменить значение репутации пользователя' do
      option name: :user, description: 'Участник, чья репутация будет изменена', type: 6, required: true
      option name: :num, description: 'Значение, на которое будет увеличена репутация', type: 4, required: true

      handler do
        opts_member.rep = ctx.opts['num'].value

        next opts_member.errors.full_messages.first unless opts_member.save

        "Операция прошла успешно, теперь у <@#{opts_member.user_id}> #{opts_member.rep} опыта"
      end
    end
  end
end
