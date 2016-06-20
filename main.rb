require_relative './freedb_entry'

def is_japanese?(text)
  text =~ /\A(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+\z/
end

# FreeDB のファイルをパースする.
#
# TITLEn -> (n + 1) 曲目の "アーティスト名 / 曲名"

freedb_files = Dir.glob("./freedb-update/**/34062806")
freedb_files.each do |file|
  next unless File.file?(file)

  entry = FreeDBEntry.new(File.read(file))
  puts entry.attrs[:tracks]
end
