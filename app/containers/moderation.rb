# frozen_string_literal: true

module ModContainer
  extend Wrap::Container

  command :ban, desc: 'Забанить нахуй', perms: (1 << 2).to_s do
    option name: :user, description: 'Цель', type: 6, required: true
    option name: :reason, description: 'Причина бана', type: 3

    handler do |act|
      target = act.guild.member(act.opts['user'].value)

      next 'Недостаточно прав' if target.get && !act.member.higher_than?(target)

      target.ban(reason: act.opts['reason']&.value)

      'Пользователь успешно забанен'
    end
  end

  command :userinfo, desc: 'Информация об участнике' do
    option name: :user, description: 'Участник, информацию о котором нужно узнать', type: 6
      
    handler do |act|
      member = helper(:opts_member, act) || helper(:current_member, act)

      <<~EOT
      Репутация: #{member.rep}
      Опыт: #{member.xp}
      EOT
    end
  end

  command :rep, desc: 'Операции с репутацией', perms: (1 << 3).to_s do
    subcommand name: :add, desc: 'Прибавить к репутации пользователя определенное значение' do
      option name: :user, description: 'Участник, чья репутация будет изменена', type: 6, required: true
      option name: :num, description: 'Значение, которое будет прибавлено к репутации', type: 4, required: true

      handler do |act|
        member = helper(:opts_member, act)
        member.rep += act.opts['num'].value

        next member.errors.full_messages.first unless member.save

        "Операция прошла успешно, теперь у <@#{member.user_id}> #{member.rep} опыта"
      end
    end

    subcommand name: :set, desc: 'Изменить значение репутации пользователя' do
      option name: :user, description: 'Участник, чья репутация будет изменена', type: 6, required: true
      option name: :num, description: 'Значение, на которое будет увеличена репутация', type: 4, required: true

      handler do |act|
        member = helper(:opts_member, act)
        member.rep = act.opts['num'].value

        next member.errors.full_messages.first unless member.save

        "Операция прошла успешно, теперь у <@#{member.user_id}> #{member.rep} опыта"
      end
    end
  end
end
