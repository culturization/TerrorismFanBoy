# frozen_string_literal: true

require 'bundler'
Bundler.require
require 'logger'
require 'yaml'
require 'active_record'

Dir['./app/helpers/*', './app/containers/*'].each { |f| require f }
require './app/models'

LOGGER = Logger.new('bot.log')

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'tfb.db'
)

Dotenv.load

@bot = Wrap::Bot.new(ENV['TOKEN']) do |bot|
  bot.intents = 33280

  bot.on_error(Wrap::Errors::MissingPermissions, 'У бота недостаточно прав')
  bot.on_error(Wrap::Errors::OtherError) { "Что-то пошло не так: #{e.message}" }

  bot.include_container(MainContainer)
  bot.include_container(ModContainer)
  bot.include_container(LevelContainer)

  bot.response_wrapper do |resp|
    { type: 4, data: { content: resp } }
  end
end