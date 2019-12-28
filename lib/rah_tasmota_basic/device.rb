# frozen_string_literal: true

require 'net/http'
require 'pry'

module RahTasmotaBasic
  # interface for the Sonoff Basic switch with Tasmota firmware installed on it
  class Device
    def initialize(ip:, user:, password:)
      @user = user
      @password = password

      @device = URI("http://#{ip}/cm")
    end

    def status
      response = send_command(command: 'Power')
      raise TasmotaError, response['WARNING'] if response['POWER'].nil?

      puts response
      response['POWER'] == 'ON'
    end

    def on
      response = send_command(command: 'Power On')
      raise TasmotaError, response['WARNING'] if response['POWER'].nil?

      puts response
      response['POWER'] == 'ON'
    end

    def off
      response = send_command(command: 'Power Off')
      raise TasmotaError, response['WARNING'] if response['POWER'].nil?

      puts response
      response['POWER'] == 'ON'
    end

    private

    def send_command(command:)
      params = { cmnd: command, user: @user, password: @password }
      uri = @device.dup
      uri.query = URI.encode_www_form(params)
      puts uri.query
      res = Net::HTTP.get_response(uri)

      JSON.parse res.body
    end
  end
end
