require 'httparty'

module Mobileminer
  module Adapter

    class API

      @@API_KEY = '64OVS1JhOcDOTn'

      include HTTParty
      base_uri 'https://mobileminer.azurewebsites.net/api'

      def initialize(email, key, logger)
        @email = email
        @key = key
        @log = logger
      end

      def statistics(machine, body)
        command("/MiningStatisticsInput#{auth_string}&machineName=#{machine}", body)
      end

      private

      def auth_string
        "?emailAddress=#{@email}&applicationKey=#{@key}&apiKey=#{@@API_KEY}"
      end

      def command(command, body)
        command = URI.encode(command)
        body = body.to_json
        @log.debug("Posting command: #{command}, body: #{body}")
        self.class.post(command, body: body, :headers => { 'Content-Type' => 'application/json' })
      end

    end

  end
end
