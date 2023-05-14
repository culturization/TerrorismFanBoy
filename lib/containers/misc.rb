# frozen_string_literal: true

module TFB
  module MiscContainer
    extend TFB::Container

    command('ping') do |bot, msg, _params|
      msg.channel.send_message('pong!')
    end
  end
end