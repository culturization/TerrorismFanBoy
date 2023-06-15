# frozen_string_literal: true

module Commands
  module Misc
    extend Wrap::Container

    register_command(name: 'ping', description: '123')

    handle_command 'ping' do
      'Pong!'
    end
  end
end