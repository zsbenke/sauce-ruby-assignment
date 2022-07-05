class InstagramReport
  attr_reader :output_files, :output_folder, :partition

  def initialize(path, output_folder:, partition: 100)
    @path = path
    @output_folder = output_folder
    @output_files = []
    @partition = partition
  end

  def prepare
    parse_json
    prepare_reports
  end

  private

  def parse_json
    parser.parse
  end

  def prepare_reports
    item_count = 0
    chunk = []

    data.each do |item|
      chunk.append clean_up_item(item)
      item_count += 1

      next unless item_count == partition

      write_chunk(chunk)

      chunk = []
      item_count = 0
    end
  end

  def parser
    @parser ||= JsonParser.new(@path)
  end

  def data
    @data ||= @parser.parsed_object
  end

  def encoder
    @encoder ||= Yajl::Encoder.new pretty: true, indent: "\t"
  end

  def clean_up_item(item)
    item[:bio]&.gsub!(/[^0-9a-z ]/i, '')
    item[:bio]&.gsub!(/\s+/, ' ')
    item[:bio]&.strip!
    item.delete :_id
    item.each_key { |key| item.delete key if item[key].is_a?(Array) && item[key].count.zero? }

    item
  end

  def write_chunk(chunk, report_name: "report_#{output_files.count}.json")
    file = File.new(File.join(output_folder, report_name), 'w')
    output_files.append file.path
    encoder.encode(chunk, file)
    file.close
  end
end
