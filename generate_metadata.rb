require 'json'
require_relative './is_japanese'

output = {}

File.open(ARGV[1]).each_line.with_index do |line, index|
  STDERR.puts "#{index} lines processed" if index % 1000 == 0

  begin
    word = line.split(",")[0]
    next unless IsJapanese::japanese?(word)

    hits = []
    File.open(ARGV[0]) do |f|
      f.any? do |line|
        if line.include?(word)
          hits << line
        end
      end
    end

    hits.each do |hit|
      album_data = JSON.parse(hit)
      output[word] ||= {
        type: 'music-artist',
        albums: []
      }
      output[word][:albums] << album_data
    end
  rescue
  end
end

puts JSON.generate(output)
