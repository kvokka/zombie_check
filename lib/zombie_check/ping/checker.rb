# frozen_string_literal: true
module ZombieCheck
  module Ping
    class Checker
      attr_accessor :hosts_file, :delay, :hosts, :report, :interrupted
      attr_reader :tool

      def initialize(options = {})
        @hosts_file ||= options[:hosts_file] || "hosts.txt"
        @delay ||= (options[:delay] || 1000).to_i
        @hosts ||= []
        @report ||= CheckerReport.new
        @tool ||= options[:tool] || "unix_ping"
        setup_interruptor
      end

      def start
        puts "Using file #{hosts_file}, delay #{delay}ms, for exit press Ctrl+C"
        loop do
          update_hosts!
          @hosts.each { |host| Thread.new { ping host } }
          interrupted_exit! if interrupted
          sleep @delay / 1000.0
        end
      end

      def ping(host)
        response = sender_class.send(:new, host).send
        @report << response
      end

      private

        def sender_class
          Object.const_get "ZombieCheck::Ping::#{tool.camel_case}"
        end

        def update_hosts!
          check_file_exists! hosts_file_path
          result = File.open(hosts_file_path, "r") { |f| f.readlines.map(&:chomp) }
          check_result_not_empty! result
          @hosts = result
        end

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

        def exit_all_threads!
          Thread.list.reject { |t| t == Thread.current }.each(&:exit)
        end

        def interrupted_exit!
          exit_all_threads!
          puts @report.generate
          exit 0
        end
    end
  end
end
