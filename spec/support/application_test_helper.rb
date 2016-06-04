# frozen_string_literal: true
require "open3"
require "fileutils"
module ApplicationTestHelper
  def run_zombie_check(options = {})
    Dir.chdir(root_path) do
      captured_stdout = ""
      ttl = options[:ttl]
      Open3.popen3("#{zombie_bin} #{options[:params]}") do |_stdin, stdout, _stderr, wait_thr|
        if ttl
          sleep ttl
          Process.kill("INT", wait_thr.pid)
        end
        captured_stdout = stdout.read
      end
    end
  end

  def create_fake_hosts_file(content)
    File.open(fake_hosts_path, "a") do |file|
      file.write(content.is_a?(Array) ? content.join("\n") : content)
    end
  end

  def remove_fake_hosts_file
    FileUtils.rm_rf(fake_hosts_path)
  end

  private

    def zombie_bin
      File.join(root_path, "bin", "zombie_check")
    end

    def root_path
      File.expand_path("../../../", __FILE__)
    end

    def fake_hosts_path
      File.join(root_path, "fake_hosts.txt")
    end
end
