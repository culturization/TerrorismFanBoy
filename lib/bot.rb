# frozen_string_literal: true

module TFB
  class Bot
    ALLOWED_METHODS = [
        'get',
        'post',
        'put',
        'patch',
        'delete'
      ]
  
    API_BASE = 'https://discord.com/api/v9/'

    attr_reader :token, :intents, :api

    attr_accessor :prefix

    def initialize(token, intents = 0, prefix = '.')
      @token = token
      @prefix = prefix

      @event_handlers = {}
      @command_handlers = {}

      @rls = {}

      @gateway = TFB::Gateway.new(self, intents)
    end

    def run
      @gateway.run
    end

    def stop(reason = nil)
      @gateway&.close(reason)
    end

    def include(*containers)
      containers.each do |cont|
        @event_handlers.merge!(cont.instance_variable_get(:@event_handlers) || {})
        @command_handlers.merge!(cont.instance_variable_get(:@command_handlers) || {})
      end
    end

    def dispatch(event, data)
      handle_command(data) if event == 'MESSAGE_CREATE'

      @event_handlers[event]&.call(data)
    end

    def channel(id)
      TFB::Channel.new(self, 'id' => id)
    end

    def message(id)
      TFB::Message.new(self, 'id' => id)
    end

    def guild(id)
      TFB::Guild.new(self, 'id' => id)
    end
  
    def api_call(method, path, rl_key = nil, data = nil)
      return unless @global_rl.nil? || Time.now > @global_rl

      if @rls.has_key?(rl_key)
        return if Time.now < @rls[rl_key]

        @rls.delete(rl_key)
      end

      res = raw_api_call(method, path, data)

      case res
      when Net::HTTPSuccess
        JSON.parse(res.body) if res.body
      when Net::HTTPTooManyRequests
        handle_ratelimit(res)
      else
        raise TFB::DiscordError.new(res)
      end
    end

    private

    def handle_command(data)
      content = data['content']

      if content.delete_prefix!(@prefix)
        cmd, *params = content.split

        @command_handlers[cmd]&.call(self, TFB::Message.new(self, data), params)
      end
    rescue DiscordError => e
      LOGGER.debug(e.message)
    end

    def handle_ratelimit(res)
      json = JSON.parse(res.body)
      retry_after = json['retry_after']

      if retry_after.nil?
        LOGGER.fatal(json['message'])
        stop('API restrict')
        return
      end

      ratelimit = Time.now + retry_after

      LOGGER.warn("ratelimitted, waiting #{retry_after} sec")

      if json['global']
        @global_rl = ratelimit
      else
        @rls[rl_key] = ratelimit
      end
    end

    def raw_api_call(method, path, data)
      method = method.to_s
  
      raise 'Invalid method' unless ALLOWED_METHODS.include?(method)
  
      uri = URI.join(API_BASE, path)
  
      http = Net::HTTP.new(uri.hostname, uri.port)
      http.use_ssl = true
  
      req = Net::HTTP.const_get(method.capitalize).new(
        uri,
        'Authorization' => @token, 'Content-Type' => 'application/json'
      )
      req.body = data.to_json if data

      http.request(req)
    end
  end
end