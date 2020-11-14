class Array
  # class Array
  def included_in? array
    array.to_set.superset?(self.to_set)
  end

  # Calcula los elementos repetidos en un array y devuelve otro array con ellos
  def repeated_elements
    self.find_all { |e| self.count(e) > 1 }.uniq
  end

  def not_repeated(array)
    self - array
  end

end