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

  def sample_variance
    return -1 if length < 2
    m = mean
    sum = inject(0) { |accum, i| accum + (i - m)**2 }
    sum / (length - 1).to_f
  end

  def standard_deviation
    sample_variance > 0 ? Math.sqrt(sample_variance) : -1
  end
end
