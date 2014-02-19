require 'json'

module Mobileminer
  module Adapter

    class Monitor

      def initialize(email, key, miners, logger)
        @email = email
        @key = key
        @miners = miners.map do |m|
          fetcher = Mobileminer::Adapter::Fetcher.new(m[:client], m[:name], logger)
          { fetcher: fetcher }.merge(m)
        end
        @log = logger
      end

      def run
        api = Mobileminer::Adapter::API.new(@email, @key, @log)

        @log.info("Monitoring #{@miners.length} miners")
        loop do
          @miners.each do |miner|
            @log.debug("Beginning miner: #{miner}")

            begin
              update = miner[:fetcher].get_update
            rescue Timeout::Error => e
              @log.warn("Timeout::Error building update for #{miner[:name]} (#{e})")
              next
              # XXX put something in the update to indicate it barfed?
            rescue SystemCallError => e
              @log.error("SystemCallError building update for #{miner[:name]} (#{e})")
              next
              # XXX put something in the update to indicate it barfed?
            rescue Exception => e
              @log.error("Exception building update for #{miner[:name]} (#{e})")
              next
              # XXX put something in the update to indicate it barfed?
            end

            @log.info("Submitting update for #{miner[:name]}")
            begin
              tries ||= 3
              response = api.statistics(miner[:name], update)
            rescue Exception => e
              @log.error("Exception submitting updates (#{e})")
              unless (tries -= 1).zero?
                @log.error('Retrying...')
                retry
              else
                @log.error('Giving up for this update...')
              end
            else
              if 201 == response.code
                @log.debug('Successfully submitted update')
              else
                @log.error('Error submitting updates, check API key!')
              end
            end
          end

          sleep 60
        end
      end

    end

  end
end
