# frozen_string_literal: true
module ZombieCheck
  module Ping
    class PingSender
      attr_accessor :duration, :host

      def initialize(host)
        @host = host
        @duration = nil
      end

      def send
        raise "Not implemented"
      end
    end
  end
end
