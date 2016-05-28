# frozen_string_literal: true
module ZombieCheck
  module Ping
    class HostStat
      attr_accessor :durations, :lost, :host

      def initialize(ping)
        @durations ||= []
        @lost ||= 0
        @host = ping.host
        if (ping_duration = ping.duration)
          @durations << (ping_duration * 1000).round(PRECISION)
        else
          @lost += 1
        end
      end

      def stored?
        stored ? true : false
      end

      def stored
        CheckerReport.nodes[host]
      end
    end
  end
end
