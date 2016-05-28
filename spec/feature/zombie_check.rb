# frozen_string_literal: true
require "spec_helper"

RSpec.describe "Test whole app" do
  context "no arguments" do
    # let(:stdout) { run_zombie_check }
    # STD net-ping timeout is 5, so we'll catch lost
    before(:context) { @stdout = run_zombie_check 6 }

    it "should include report on start" do
      expect(@stdout).to match(/To 127.0.0.1 total sent \d+ pings/)
    end

    it "should include trying to ping 127.0.0.1" do
      expect(@stdout).to include("Using file hosts.txt, delay 1000ms, for exit press Ctrl+C")
    end

    it "should not receive nothing from 1.1.1.1" do
      expect(@stdout).to match(/To 1.1.1.1 total sent \d+ pings, lost \d+ \(100\.0%\)/)
    end

    it "should include report on the exit" do
      expect(@stdout).to include("total sent")
    end
  end

  context "making the delay 10ms" do
    before(:context) { @stdout = run_zombie_check 3, "delay:10" }

    it "Sent package cound should be different" do
      expect(@stdout.scan(/total sent (\d+)/).uniq).to_not eq 1
    end
  end

  context "use custom hosts file" do
    before(:context) { create_fake_hosts_file }
    before(:context) { @stdout = run_zombie_check 3, "hosts_file:fake_hosts.txt" }
    after(:context) { remove_fake_hosts_file }

    it "Apply own hosts file" do
      expect(@stdout).to match(/To vk.com total sent \d+ pings/)
    end
  end
end
