module Mobileminer
  module Adapter

    class Fetcher

      def initialize(client, name, logger)
        @client = client
        @name = name
        @log = logger
      end

      def get_update
        devs = @client.devs
        details = @client.devdetails
        pools = @client.pools

        # XXX check status replies on each command?

        updates = []
        devs.body.each do |dev|
          update = host_info
          if dev.has_key? 'GPU'
            update['Kind'] = update['Name'] = 'GPU'
            update['FullName'] = find_device_details(details.body, :gpu, dev['GPU'])['Model']
            update.merge!(gpu_info(dev))
          elsif dev.has_key? 'ASC'
            update['Kind'] = update['Name'] = 'ASC'
            update['FullName'] = find_device_details(details.body, :asc, dev['ASC'])['Model']
            update.merge!(asic_info(dev))
          elsif dev.has_key? 'PGA'
            update['Kind'] = update['Name'] = 'PGA'
            update['FullName'] = find_device_details(details.body, :pga, dev['PGA'])['Model']
            update.merge!(fpga_info(dev))
          else
            @log.warn("Skipped unknown device: #{dev}")
          end

          active_pool = pools.body.select { |pool| pool['Stratum Active'] }.first
          update['PoolIndex'] = active_pool['POOL']
          update['PoolName'] = active_pool['URL']

          updates << update
        end

        @log.debug("Built update: #{updates}")
        updates
      end

      private

      def find_device_details(details, type, index)
        details.select { |detail| detail['Name'] == type.to_s.upcase }[index]
      end

      def find_mhash_current(blob)
        blob[blob.keys.select { |k| /MHS \ds/.match(k) }.first] || 0
      end

      def host_info
        {
          'MinerName' => 'mobileminer-adapter-gem',
          'CoinSymbol' => 'LTC',
          'CoinName' => 'Litecoin',
          'Algorithm' => 'scrypt',
        }
      end

      def device_info(device)
        {
          'Temperature' => device['Temperature'],
          'Enabled' => device['Enabled'] == 'Y',
          'Status' => device['Status'],
          'AverageHashrate' => device['MHS av'].to_f * 1000.0,
          'CurrentHashrate' => find_mhash_current(device) * 1000.0,
          'AcceptedShares' => device['Accepted'],
          'RejectedShares' => device['Rejected'],
          'HardwareErrors' => device['Hardware Errors'],
          'Utility' => device['Utility'],
          'RejectedSharesPercent' => device['Device Rejected%'],
        }
      end

      def asic_info(device)
        {
          'Index' => device['ASC'],
        }.merge(device_info(device))
      end

      def fpga_info(device)
        {
          'Index' => device['PGA'],
        }.merge(device_info(device))
      end

      def gpu_info(device)
        {
          'Index' => device['GPU'],
          'FanSpeed' => device['Fan Speed'],
          'FanPercent' => device['Fan Percent'],
          'GpuClock' => device['GPU Clock'],
          'MemoryClock' => device['Memory Clock'],
          'GpuVoltage' => device['GPU Voltage'],
          'GpuActivity' => device['GPU Activity'],
          'PowerTune' => device['Powertune'],
          'Intensity' => device['Intensity'],
        }.merge(device_info(device))
      end

      def pool_info(pool)
        {
          'PoolIndex' => pool['POOL'],
          'PoolName' => pool['URL'],
        }
      end

    end

  end
end
