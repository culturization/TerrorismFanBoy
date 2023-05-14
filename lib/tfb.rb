# frozen_string_literal: true

require 'logger'
require 'websocket-client-simple'
require 'json'
require 'net/http'
require './lib/gateway'
require './lib/bot'
require './lib/container'
require './lib/errors'

Dir['./lib/models/*.rb', './lib/containers/*.rb'].each { |f| require f }

module TFB
  LOGGER = Logger.new(STDOUT)
  LOGGER.level = Logger::DEBUG
  VERSION = '0.1'
end