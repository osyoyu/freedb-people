require_relative './freedb_entry'
require 'pp'

def japanese?(text)
  text =~ /\A(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+\z/
end

# 複数の文字列のどれかが日本語であるかを高速に当てるための最悪なメソッド
def multi_japanese?(*texts)
  joined_text = texts.join('')
  japanese?(joined_text)
end

dirs = ARGV
threads = []
dirs.each do |dir|
  threads << Thread.new {
    freedb_files = Dir.glob("#{dir}/**/*")
    freedb_files.each do |file|
      next unless File.file?(file)

      begin
        entry = FreeDBEntry.new(File.read(file))

        if multi_japanese?(entry.attrs[:title], entry.attrs[:artist])
          puts "\"#{entry.attrs[:artist]}\",\"#{entry.attrs[:title]}\",\"#{entry.attrs[:genre]}\""
        end
      rescue => e
        next
      end
    end
  }
end

threads.each { |thr| thr.join }
