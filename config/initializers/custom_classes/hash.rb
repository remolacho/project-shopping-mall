class Hash
  def grep(pattern)
    inject([]) do |res, kv|
      res << kv if kv[0] =~ pattern or kv[1] =~ pattern
      res
    end
  end

  def last_value
    values.last
  end

  def deep_reject(&block)
    self.dup.deep_reject!(&block)
  end

  def deep_reject!(&block)
    self.each do |k, v|
      v.deep_reject!(&block) if v.is_a?(Hash)
      self.delete(k) if block.call(k, v)
    end
  end

  def deep_hierarchy(&block)
    stack = self.map {|k, v| [[k], v]}
    until stack.empty?
      key, value = stack.pop
      yield(key, value)
      if value.is_a? Hash
        value.each {|k, v| stack.push [key.dup << k, v]}
      end
    end
  end

  def without(*keys)
    dup.without!(*keys)
  end

  def without!(*keys)
    reject! { |key| keys.include?(key) }
  end

  def only(*args)
    select {|k,v| args.include?(k) }
  end


end