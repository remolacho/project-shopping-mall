class String

  def str_slug
    self.downcase.strip.gsub(/\s+/, ' ').gsub(' ', '-').gsub(/[^\w-]/, '')
  end

  def white_space
    self.downcase.strip.gsub(/\s+/, ' ').gsub(' ', '').gsub(/[^\w-]/, '')
  end

  def numeric?
    Float(self) != nil rescue false
  end
end
