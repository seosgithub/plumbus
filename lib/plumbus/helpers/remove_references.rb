class Hash
  def remove_references! obj
    self.select{|k, v| [Array, Hash].include? v.class}.each do |k, v|
      v.remove_references! obj
    end
    self.select{|k, v| not [Array, Hash].include? v.class}.each do |k, v|
      if v == obj
        self.delete(k)
      end
    end

    self
  end
end

class Array
  def remove_references! obj
    self.select{|e| [Array, Hash].include? e.class}.each do |e|
      e.remove_references! obj
    end

    self.select{|e| not [Array, Hash].include? e.class}.each_with_index do |e, i|
      if e == obj
        self.delete(obj)
      end
    end

    self
  end
end
