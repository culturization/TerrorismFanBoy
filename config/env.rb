# frozen_string_literal: true

require 'bundler'
Bundler.require
require 'logger'
require 'yaml'
require 'active_record'

LOGGER = Logger.new('bot.log')

require './config/db'
require_all './app'