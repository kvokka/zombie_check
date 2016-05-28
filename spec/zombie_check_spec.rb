# frozen_string_literal: true
require "spec_helper"

describe ZombieCheck do
  it "has a version number" do
    expect(ZombieCheck::VERSION).not_to be nil
  end

  describe Enumerable do
    context "good data" do
      it "#sum" do
        expect((1..100).to_a.sum).to eq(5050)
      end

      it '#mean' do
        expect((1..999).to_a.mean).to eq(500)
      end

      it '#median with even elements array' do
        expect((1..999).to_a.median).to eq(500)
      end

      it '#median with odd elements array' do
        expect((1..1000).to_a.median).to eq(500)
      end

      it '#sigma simple' do
        expect((1..3).to_a.sigma).to eq(1)
      end

      it '#sigma hard' do
        expect((1..15).to_a.sigma.round(10)).to eq(4.472135955)
      end
    end
  end

  describe ZombieCheck::Ping::HostStat do
    subject { ZombieCheck::Ping::HostStat }
    context "lost package" do
      let(:host_stat) { subject.new FakePing.new(lost: true) }
      it "creates stat instance with lost package" do
        expect(host_stat.lost).to eq 1
      end

      it "creates stat instance out durations" do
        expect(host_stat.durations.length).to eq 0
      end
    end

    context "delivered package" do
      let(:host_stat) { subject.new FakePing.new }
      it "creates stat instance delivered package" do
        expect(host_stat.lost).to eq 0
      end

      it "creates stat instance out durations" do
        expect(host_stat.durations.length).to eq 1
      end
    end
  end

  describe ZombieCheck::Ping::CheckerReport do
    subject { ZombieCheck::Ping::CheckerReport }
    context "send many pings" do
      before(:context) do
        @hosts = []
        10.times do
          ZombieCheck::Ping::CheckerReport.store ZombieCheck::Ping::HostStat.new(ping = FakePing.new)
          @hosts << ping.host
        end
      end

      it "check host count" do
        expect(subject.nodes.length).to eq 10
      end

      it "check host names in report" do
        expect(subject.nodes.keys).to match_array @hosts
      end
    end
  end
end
