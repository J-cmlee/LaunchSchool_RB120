def number?(obj)
  obj.to_s == obj.to_i.to_s
end

p number?("2")