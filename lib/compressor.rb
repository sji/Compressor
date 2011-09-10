class CSSCompressor
  attr_accessor :file_name, :regex, :raw_text, :compressed_text
  
  def initialize filename, options = {}
    self.file_name = filename
    self.regex = options.fetch :regex, true
  end
  
  def compress_to destination_filename
    raise "Invalid File: #{self.file_name}" unless File.exists? self.file_name
    
    File.open(File.expand_path(self.file_name)) { |file| self.raw_text = file.read }
    self.compressed_text = self.regex ? regex_compress(self.raw_text) : compress(self.raw_text)
    File.open(destination_filename, 'w') { |file| file << self.compressed_text }
  end
  
  private
  def compress string
    map = string.each_line.map do |line|
      stript = line.strip
      stript.empty? || (stript.start_with?('/*') && stript.end_with?('*/')) ? '' : line  
    end
    map.join ''
  end
  
  def regex_compress string
    string.gsub(/\/\*(.|\n|\r)*?\*\//, '').gsub(/^\s*\n/, '')
  end
end