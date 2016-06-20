module IsJapanese
  def self.japanese?(text)
    text =~ /(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+/
  end
end
