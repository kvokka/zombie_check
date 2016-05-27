# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "zombie_check/version"

Gem::Specification.new do |spec|
  spec.name          = "zombie_check"
  spec.version       = ZombieCheck::VERSION
  spec.authors       = ["Kvokka"]
  spec.email         = ["root_p@mail.ru"]

  spec.summary       = "Ping all from file list"
  spec.description   = "Ping all from file list"
  spec.homepage      = "https://github.com/kvokka/zombie_check"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ["zombie_check"]
  spec.require_paths = ["lib"]
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.0.0"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
