# frozen_string_literal: true

module Containers
  module Misc
    extend Wrap::Container

    command :ping, desc: 'Pings bot' do
      handler { 'Pong!' }
    end
  end
end
