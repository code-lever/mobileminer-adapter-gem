module Mobileminer
  module Adapter

    class Fetcher

      def initialize(client, name, logger)
        @client = client
        @name = name
        @log = logger
      end

      def get_update
        version = @client.version
        summary = @client.summary
        devs = @client.devs
        pools = @client.pools

        # XXX check status replies on each command?

        update = host_info(summary, version)

        devs.body.each do |dev|
          if dev.has_key? 'GPU'
            update[:gpus] << gpu_info(dev)
          elsif dev.has_key? 'ASC'
            update[:asics] << asic_info(dev)
          elsif dev.has_key? 'PGA'
            update[:fpgas] << fpga_info(dev)
          else
            @log.warn("Skipped unknown device: #{dev}")
          end
        end

        pools.body.each do |pool|
          update[:pools] << pool_info(pool)
        end

        @log.debug("Built update: #{update}")
        update
      end

      private

      def find_mhash_current(blob)
        blob[blob.keys.select { |k| /MHS \ds/.match(k) }.first] || 0
      end

      def host_info(summary, version)
        sum = summary.body[0]
        ver = version.body[0]
        {
          host: @name,
          uptime: sum['Elapsed'],
          mhash_average: sum['MHS av'],
          mhash_current: find_mhash_current(sum),
          found_blocks: sum['Found Blocks'],
          getworks: sum['Getworks'],
          accepted: sum['Accepted'],
          rejected: sum['Rejected'],
          hardware_errors: sum['Hardware Errors'],
          utility: sum['Utility'],
          discarded: sum['Discarded'],
          stale: sum['Stale'],
          get_failures: sum['Get Failures'],
          local_work: sum['Local Work'],
          remote_failures: sum['Remote Failures'],
          network_blocks: sum['Network Blocks'],
          total_mhash: sum['Total MH'],
          work_utility: sum['Work Utility'],
          difficulty_accepted: sum['Difficulty Accepted'],
          difficulty_rejected: sum['Difficulty Rejected'],
          difficulty_stale: sum['Difficulty Stale'],
          best_share: sum['Best Share'],
          device_hardware_percent: sum['Device Hardware%'],
          device_rejected_percent: sum['Device Rejected%'],
          pool_rejected_percent: sum['Pool Rejected%'],
          pool_stale_percent: sum['Pool Stale%'],
          api_version: ver['API'],
          cgminer_version: ver['CGMiner'],
          sgminer_version: ver['SGMiner'],
          asics: [],
          fpgas: [],
          gpus: [],
          pools: [],
          agent: {
            name: 'mobileminer-adapter-gem',
            platform: RUBY_PLATFORM,
            version: Brigade::Monitor::VERSION
          }
        }
      end

      def device_info(device)
        {
          temperature: device['Temperature'],
          enabled: device['Enabled'] == 'Y',
          status: device['Status'],
          uptime: device['Device Elapsed'],
          mhash_average: device['MHS av'],
          mhash_current: find_mhash_current(device),
          accepted: device['Accepted'],
          rejected: device['Rejected'],
          hardware_errors: device['Hardware Errors'],
          utility: device['Utility'],
          rejected_percent: device['Device Rejected%'],
          last_share_pool: device['Last Share Pool'],
          last_share_time: device['Last Share Time'],
          total_mhash: device['Total MH'],
          diff1_work: device['Diff1 Work'],
          difficulty_accepted: device['Difficulty Accepted'],
          difficulty_rejected: device['Difficulty Rejected'],
          last_share_difficulty: device['Last Share Difficulty'],
          last_valid_work: device['Last Valid Work'],
        }
      end

      def asic_info(device)
        {
          index: device['ASC'],
        }.merge(device_info(device))
      end

      def fpga_info(device)
        {
          index: device['PGA'],
          frequency: device['Frequency'],
        }.merge(device_info(device))
      end

      def gpu_info(device)
        {
          index: device['GPU'],
          fan_speed: device['Fan Speed'],
          fan_percent: device['Fan Percent'],
          gpu_clock: device['GPU Clock'],
          memory_clock: device['Memory Clock'],
          gpu_voltage: device['GPU Voltage'],
          gpu_activity: device['GPU Activity'],
          powertune: device['Powertune'],
          intensity: device['Intensity'],
        }.merge(device_info(device))
      end

      def pool_info(pool)
        {
          index: pool['POOL'],
          url: pool['URL'],
          status: pool['Status'],
          priority: pool['Priority'],
          quota: pool['Quota'],
          longpoll: pool['Long Poll'] == 'Y',
          getworks: pool['Getworks'],
          accepted: pool['Accepted'],
          rejected: pool['Rejected'],
          works: pool['Works'],
          discarded: pool['Discarded'],
          stale: pool['Stale'],
          get_failures: pool['Get Failures'],
          remote_failures: pool['Remote Failures'],
          user: pool['User'],
          last_share_time: pool['Last Share Time'],
          diff1_shares: pool['Diff1 Shares'],
          proxy_type: pool['Proxy Type'],
          proxy: pool['Proxy'],
          difficulty_accepted: pool['Difficulty Accepted'],
          difficulty_rejected: pool['Difficulty Rejected'],
          difficulty_stale: pool['Difficulty Stale'],
          last_share_difficulty: pool['Last Share Difficulty'],
          has_stratum: pool['Has Stratum'],
          stratum_url: pool['Stratum URL'],
          has_gbt: pool['Has GBT'],
          best_share: pool['Best Share'],
          active: pool['Stratum Active'],
          pool_rejected_percent: pool['Pool Rejected%'],
          pool_stale_percent: pool['Pool Stale%'],
        }
      end

    end

  end
end
