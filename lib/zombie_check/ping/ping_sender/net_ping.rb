# frozen_string_literal: true
module ZombieCheck
  module Ping
    class NetPing < PingSender
      def initialize(host)
        super host
      end

      def send
        icmp = Net::Ping::ICMP.new(host)
        icmp.ping
        self.duration = icmp.duration
        self
      end
    end
  end
end
