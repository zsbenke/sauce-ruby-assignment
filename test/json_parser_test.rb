# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/json_parser'

class JsonParserTest < Minitest::Test
  def setup
    @json_path = File.join(File.dirname(__FILE__), 'fixtures', '1000-users.json')
    @parser = JsonParser.new @json_path
  end

  def test_returning_the_path
    assert_equal @json_path, @parser.path
  end

  def test_setting_path_to_nil_when_path_is_invalid
    assert_nil JsonParser.new('foo/bar').path
  end

  def test_parsing_a_json
    @parser.parse

    assert @parser.object.is_a?(Array)
    assert_equal 1000, @parser.object.count

    @parser.object.each do |object|
      assert object.is_a?(Hash)
      assert_equal %i[_id id type username bio followed_by mentions hashtags], object.keys
    end
  end

  def test_parsing_a_json_with_a_block
    @parser.parse do |line|
      assert_equal String, line.class
    end
  end
end
