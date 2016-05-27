# frozen_string_literal: true
module ZombieCheck
  module Ping
    class HostStat
      @nodes = {}

      class<<self
        attr_accessor :nodes
      end

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

      def store
        if stored?
          stored.durations += durations
          stored.lost += lost
        else
          self.class.nodes[host] = self
        end
      end

      def stored?
        stored ? true : false
      end

      def stored
        self.class.nodes[host]
      end

      def hash
        host.hash
      end
    end
  end
end
