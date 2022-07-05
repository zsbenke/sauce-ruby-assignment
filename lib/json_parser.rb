# frozen_string_literal: true

require 'yajl'

# Parses JSON file into an object.
class JsonParser
  attr_reader :path, :object

  def initialize(path)
    return unless File.exist?(path)

    @path = path
    @parser = Yajl::Parser.new(symbolize_keys: true)
    @parser.on_parse_complete = method(:object_parsed)
  end

  def parse
    file = File.open(path, 'r')

    file.each_line do |line|
      @parser << line

      yield(line) if block_given?
    end

    file.close
  end

  private

  def object_parsed(obj)
    @object = obj
  end
end
