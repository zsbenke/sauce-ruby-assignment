# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/some_object'

class SomeObjectTest < Minitest::Test
  def test_checking_if_the_test_works
    assert SomeObject.new.works?
  end
end
