# frozen_string_literal: true
class FakePing
  attr_accessor :duration, :host
  def initialize(params = {})
    @host = params[:host] || generate_host
    @duration = params[:lost] ? nil : rand * 4
  end

  private

    def generate_host
      Array.new(4) { rand(255) }.join(".")
    end
end
