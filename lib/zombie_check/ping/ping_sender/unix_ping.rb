# frozen_string_literal: true
module ZombieCheck
  module Ping
    class UnixPing < PingSender
      def initialize(host)
        super host
      end

      def send
        result = `ping -c 1 -W 5 #{host}`.match(/time=(\d+\.?\d*)/)
        self.duration = result[1].to_f / 1000 if result
        self
      end
    end
  end
end
