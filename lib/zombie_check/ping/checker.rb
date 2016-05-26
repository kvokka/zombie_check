# frozen_string_literal: true
module ZombieCheck
  module Ping
    class Checker
      attr_accessor :hosts_file, :delay, :hosts

      def initialize(options = {})
        @hosts_file ||= options[:hosts_file] || "hosts.txt"
        @delay ||= options[:delay].to_i || 1
        @hosts ||= []
      end

      def start
        puts "Using file #{hosts_file}, delay #{delay}, for exit press Ctrl+C"
        begin
        loop do
          @hosts = parse_host_file
          sleep @delay
        end
      rescue SignalException
        puts "Exiting..."
      rescue => e
        puts "Error during processing: #{$ERROR_INFO}"
        puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
        raise
      ensure
        puts
        puts "Summary will be here #{hosts}"
      end
      end

      def parse_host_file
        hosts_file_path = File.expand_path(@hosts_file)
        unless File.exist?(hosts_file_path)
          puts "No #{@hosts_file} file"
          exit 0
        end
        result = File.open(hosts_file_path, "r") { |f| f.readlines.map(&:chomp) }
        if result.empty?
          puts "#{@hosts_file} is empty"
          exit 0
        end
        result
      end
    end
  end
end
