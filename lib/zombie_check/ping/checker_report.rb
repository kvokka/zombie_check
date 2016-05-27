# frozen_string_literal: true
require 'pry'
module ZombieCheck
  module Ping
    class CheckerReport

      def <<(ping)
        HostStat.new(ping).store
      end

      def generate
        [].tap do |result|
          HostStat.nodes.each_pair do |host, node|
            total = node.durations.size + node.lost
            percentage = total > 0 ? node.lost / total : 0
            result << <<-REPORT

To #{host} total sent #{total} pings, lost #{node.lost} (#{percentage}%). Time(ms):
AVG #{node.durations.mean.round(PRECISION)} MIN #{node.durations.min} \
MAX #{node.durations.max} sigma #{node.durations.sigma.round(PRECISION)} \
median #{node.durations.median.round(PRECISION)}
        REPORT
          end
        end.join "\n"
      end
    end
  end
end
