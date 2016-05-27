# frozen_string_literal: true
module Enumerable
  def sum
    inject(0) { |accum, i| accum + i }
  end

  def mean
    # rubocop bug, other way it dies https://github.com/bbatsov/rubocop/issues/3169
    return -1 if send(:length) == 0
    sum / length.to_f
  end

  def sigma
    return -1 if length < 2
    m = mean
    sum = inject(0) { |accum, i| accum + (i - m)**2 }
    Math.sqrt(sum / (length - 1).to_f)
  end

  def median
    return -1 if send(:length) == 0
    middle = length / 2
    sorted = sort
    length.even? ? (sorted[middle] + sorted[middle - 1]) / 2 : sorted[middle]
  end
end
