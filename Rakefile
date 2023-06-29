# frozen_string_literal: true

require './app/bot'

namespace :db do
  task :migrate do
    require './db/migrations'
    [
      CreateGuilds,
      CreateMembers,
      CreateActions,
      CreateTempmutes,
      CreateTempbans,
      CreateTemproles,
      CreateModeratorships
    ].each { _1.migrate(:change) }
  end

  task :drop do
    File.delete('tfb.db')
  end
end

namespace :discord do
  task :overwrite_commands do
    @bot.on_event :ready do
      @bot.overwrite_commands
      @bot.stop
    end

    @bot.run
  end
end
