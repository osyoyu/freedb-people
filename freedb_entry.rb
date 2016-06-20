class FreeDBEntry
  attr_accessor :attrs

  def initialize(text)
    @text = text

    @attrs = {
      comment: '',
      tracks: []
    }

    parse!
  end

  def parse!
    @text.each_line do |line|
      parse_line!(line.chomp)
    end
  end

  def parse_line!(line)
    if line[0] == '#'
      add_comment!(line[2..-1])
    else
      key, value = line.split("=", 2)
      add_attr!(key, value)
    end
  end

  def add_comment!(line)
    @attrs[:comment] += "#{line}\n"
  end

  def add_attr!(key, value)
    if key.start_with?('TTITLE')
      track_number = key.match(/TTITLE(\d)/)[1].to_i
      @attrs[:tracks][track_number] ||= {
        track_number: track_number,
        title: ''
      }

      @attrs[:tracks][track_number][:title] += value
    end
  end
end
