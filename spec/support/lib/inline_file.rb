class InlineFile
  def initialize str
    @str = str
  end

  def path!
    file = Tempfile.new("inline_file")
    file.write @str
    file.close
    file.path
  end
end

class String
  def to_file
    inline_file = InlineFile.new self

    return inline_file.path!
  end
end
