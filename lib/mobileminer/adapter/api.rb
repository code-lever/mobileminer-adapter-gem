require 'httparty'

module Brigade
  module Monitor

    class API

      @@API_KEY = '64OVS1JhOcDOTn'

      include HTTParty
      base_uri 'https://mobileminer.azurewebsites.net/api'

      def initialize(email, key, logger)
        @email = email
        @key = key
        @log = logger
      end

      def statistics(machine, data)
        command("/MiningStatisticsInput#{auth_string}&machineName=#{machine}", updates: data)
      end

      private

      def auth_string
        "?emailAddress=#{@email}&applicationKey=#{@key}&apiKey=#{@@API_KEY}"
      end

      def command(command, params)
        @log.debug("Posting command: #{command}, data: #{params}")
        #self.class.post(command, body: params)
      end

    end

  end
end
