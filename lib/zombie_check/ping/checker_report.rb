# frozen_string_literal: true
module ZombieCheck
  module Ping
    class CheckerReport
      PRECISION = 3
      attr_accessor :stat

      def initialize
        @stat ||= {}
      end

      def <<(ping)
        host = @stat[ping.host] ||= {}
        host[:durations] ||= []
        host[:lost] ||= 0
        if (ping_duration = ping.duration)
          host[:durations] << (ping_duration * 1000).round(PRECISION)
        else
          host[:lost] += 1
        end
      end

      def generate
        [].tap do |result|
          stat.each_pair do |host, log|
            total = log[:durations].size + log[:lost]
            percentage = total > 0 ? log[:lost] / total : 0

            result << <<-REPORT
To #{host} total sent #{total} pings, lost #{log[:lost]} (#{percentage}%). Time(ms):
AVG #{log[:durations].mean.round(PRECISION)} MIN #{log[:durations].min} \
MAX #{log[:durations].max} STD_VARIANCE #{log[:durations].sample_variance.round(PRECISION)} \
STD_DEVIATION #{log[:durations].standard_deviation.round(PRECISION)}
        REPORT
          end
        end.join "\n"
      end
    end
  end
end
