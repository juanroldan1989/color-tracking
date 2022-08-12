class Colors
  def self.list
    Color.select(:name).pluck(:name).sort
  end
end
