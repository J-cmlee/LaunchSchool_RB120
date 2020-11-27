
def marked?
  true
end

markers = ["X","X","O"]
p markers.collect(&:to_sym)