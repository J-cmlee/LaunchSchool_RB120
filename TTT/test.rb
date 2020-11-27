def joinor(array)
  values = array.clone
  last_value = values.pop

  return last_value if values.empty?
  values[-1] += " or #{last_value}"
  values.join(", ")
end

p joinor(['a','b','c'])