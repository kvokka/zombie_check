# frozen_string_literal: true
class String
  def camel_case
    split("_").map(&:capitalize).join
  end
end
