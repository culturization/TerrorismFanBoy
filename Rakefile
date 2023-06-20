# frozen_string_literal: true

require './config/env'

namespace :db do
  task :migrate do
    require './config/db'
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
    require './lib/tfb'
    require 'dotenv/load'

    bot = TFB::Bot.new(ENV['TOKEN'])
    bot.overwrite_commands
  end
end
