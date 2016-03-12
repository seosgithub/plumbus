class Hash
  #Removes all sub-hashes & arrays that have no objects in them.
  def trim!
    self.each do |k, v|
      if v.class == Array

        v.trim!

        #Blank array, dump it
        if v.count == 0
          self.delete k
        end
      elsif v.class == Hash
        v.trim!

        if v.keys.count == 0
          self.delete k
        end
      end
    end

    return self
  end
end

class Array
  def trim!
    self.each do |e|
      if e.class == Hash
        e.trim!

        if e.keys.count == 0
          self.delete e
        end
      elsif e.class == Array
        e.trim!
        if e.count == 0
          self.delete(e)
        end
      end
    end

    return self
  end
end
