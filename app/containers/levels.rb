# frozen_string_literal: true

module LevelContainer
  extend Wrap::Container

  command :xp, desc: 'Операции с опытом', perms: ?0 do
    subcommand name: :set_multiplier, desc: 'Установить значение множителя опыта' do
      option name: :multiplier, description: 'Собственно множитель', type: 4, required: true

      handler do
        current_guild.xp_multiplier = ctx.opts['multiplier'].value

        next current_guild.errors.full_messages unless current_guild.save

        'Множитель опыта сохранен'
      end
    end

    subcommand name: :set, desc: 'Установить значение опыта у пользователя' do
      option name: :user, description: 'Так называемый участник сервера', type: 6, required: true
      option name: :xp, description: 'Значение опыта', type: 4, required: true

      handler do
        opts_member.xp = ctx.opts['xp'].value

        next opts_member.errors.full_messages unless opts_member.save

        "Операция прошла успешно, у <@#{opts_member.user_id}> теперь #{opts_member.xp} опыта"
      end
    end

    subcommand name: :add, desc: 'Добавить опыт пользователю' do
      option name: :user, description: 'Участник', type: 6, required: true
      option name: :xp, description: 'Значение, на которое будет увеличен показатель опыта', type: 4, required: true

      handler do
        opts_member.xp += ctx.opts['xp'].value

        next opts_member.errors.full_messages unless opts_member.save

        "Операция прошла успешно, у <@#{opts_member.user_id}> теперь #{opts_member.xp} опыта"
      end
    end
  end

  on_event :message_create do |msg|
    next

    @last_xp_msgs ||= {}

    guild = @bot.guild(msg.guild_id)
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
