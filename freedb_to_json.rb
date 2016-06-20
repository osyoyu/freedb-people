require 'json'
require 'pp'
require_relative './freedb_entry'

dirs = ARGV
threads = []
dirs.each do |dir|
  threads << Thread.new {
    freedb_files = Dir.glob("#{dir}/**/*")
    freedb_files.each do |file|
      next unless File.file?(file)

      begin
        entry = FreeDBEntry.new(File.read(file))

        if entry.attrs[:is_japanese]
          # puts "\"#{entry.attrs[:artist]}\",\"#{entry.attrs[:title]}\",\"#{entry.attrs[:genre]}\""
          json = JSON.generate({
              title: entry.attrs[:title],
              artist: entry.attrs[:artist],
              genre: entry.attrs[:genre],
              tracks: entry.attrs[:tracks]
          })
          puts json
        end
      rescue => e
        p e
        next
      end
    end
  }
end

threads.each { |thr| thr.join }
