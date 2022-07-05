require 'minitest/autorun'
require_relative '../lib/instagram_report'
require_relative '../lib/json_parser'

class InstagramReportTest < Minitest::Test
  def setup
    @output_folder = File.expand_path(File.join(File.dirname(__FILE__), '..', 'tmp'))
    FileUtils.mkdir_p @output_folder

    @json_path = File.join(File.dirname(__FILE__), 'fixtures', '1000-users.json')
    @report = InstagramReport.new @json_path, output_folder: @output_folder
  end

  def test_preparing_report
    @report.prepare

    assert_equal 10, @report.output_files.count

    @report.output_files.each do |output_file|
      parser = JsonParser.new output_file
      parser.parse

      assert_equal 100, parser.parsed_object.count
    end
  end

  def teardown
    FileUtils.rm_rf @output_folder
  end
end
