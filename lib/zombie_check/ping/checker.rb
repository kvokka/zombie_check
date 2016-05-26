# frozen_string_literal: true
module ZombieCheck
  module Ping
    class Checker
      attr_accessor :hosts_file, :delay, :hosts, :report, :interrupted

      def initialize(options = {})
        @hosts_file ||= options[:hosts_file] || "hosts.txt"
        @delay ||= (options[:delay].to_i || 1000) / 1000.0
        @hosts ||= []
        @report = CheckerReport.new
        setup_interruptor
      end

      def start
        puts "Using file #{hosts_file}, delay #{delay}, for exit press Ctrl+C"
        begin
        loop do
          update_hosts!
          @hosts.each do |h|
            icmp = Net::Ping::ICMP.new(h)
            icmp.ping
            @report << icmp
          end
          exit if interrupted
          # sleep @delay
        end
      ensure
        puts
        puts "Summary will be here #{@report.generate}"
      end
      end

      def update_hosts!
        check_file_exists! hosts_file_path
        result = File.open(hosts_file_path, "r") { |f| f.readlines.map(&:chomp) }
        check_result_not_empty! result
        @hosts = result
      end

      private

        def check_file_exists!(file)
          return if File.exist?(file)
          puts "No #{@hosts_file} file"
          exit 0
        end

        def check_result_not_empty!(result)
          return unless result.empty? && @hosts.empty?
          puts "#{@hosts_file} is empty"
          exit 0
        end

        def hosts_file_path
          File.expand_path(@hosts_file)
        end

        def setup_interruptor
          trap("INT") { @interrupted = true }
        end
    end
  end
end
