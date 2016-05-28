# frozen_string_literal: true
module ZombieCheck
  module Ping
    class CheckerReport
      @nodes = {}

      class<<self
        attr_accessor :nodes

        def store(ping)
          if ping.stored?
            nodes[ping.host].durations += ping.durations
            nodes[ping.host].lost += ping.lost
          else
            nodes[ping.host] = ping
          end
        end
      end

      def <<(ping)
        store(HostStat.new(ping))
      end

      def generate
        [].tap do |result|
          nodes.each_pair do |host, node|
            total = node.durations.size + node.lost
            percentage = total > 0 ? (node.lost.to_f / total * 100).round(PRECISION) : 0
            result << <<-REPORT

To #{host} total sent #{total} pings, lost #{node.lost} (#{percentage}%). Time(ms):
AVG #{node.durations.mean.round(PRECISION)} MIN #{node.durations.min} \
MAX #{node.durations.max} sigma #{node.durations.sigma.round(PRECISION)} \
median #{node.durations.median.round(PRECISION)}
        REPORT
          end
        end.join "\n"
      end

      private

        def store(*args)
          self.class.store(*args)
        end

        def nodes
          self.class.nodes
        end
    end
  end
end
