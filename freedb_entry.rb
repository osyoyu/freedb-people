class FreeDBEntry
  attr_accessor :attrs

  def initialize(text)
    @text = text

    @attrs = {
      raw: {},
      comment: '',
      title: '',
      artist: '',
      tracks: [],
      is_japanese: nil
    }

    parse!
  end

  def parse!
    @text.each_line do |line|
      parse_line!(line.chomp)
    end

    track_info = parse_track_title(@attrs[:raw]['DTITLE'])
    @attrs[:title] = track_info[:title]
    @attrs[:artist] = track_info[:artist]
    @attrs[:genre] = @attrs[:raw]['DGENRE']
    normalize_titles!
  end

  def parse_line!(line)
    line = line.encode("UTF-16BE", "UTF-8", :invalid => :replace, :undef => :replace, :replace => '?').encode("UTF-8")
    @attrs[:is_japanese] ||= japanese?(line)

    if line[0] == '#'
      add_comment!(line[2..-1])
    else
      key, value = line.split("=", 2)
      add_raw_attr!(key, value)
    end
  end

  def add_comment!(line)
    @attrs[:comment] += "#{line}\n"
  end

  def add_raw_attr!(key, value)
    @attrs[:raw][key] ||= ''
    @attrs[:raw][key] += value
  end

  def normalize_titles!
    @attrs[:raw].each do |key, value|
      if key.start_with?('TTITLE')
        track_number = key.match(/TTITLE(\d)/)[1].to_i
        track_info = parse_track_title(value)

        @attrs[:tracks][track_number] = {
          track_number: track_number,
          title: track_info[:title],
          artist: track_info[:artist]
        }
      end
    end
  end

  def parse_track_title(str)
    data = str.match(%r{([^,/]+) [,/] (.+)})

    if data.size == 3
      {
        title: data[2].strip,
        artist: data[1].strip
      }
    else
      {
        title: str,
        artist: ''
      }
    end

  rescue
    {
      title: str,
      artist: ''
    }
  end

  def japanese?(text)
    text =~ /(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+/
  end
end
