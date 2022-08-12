class Colors
  def self.list
    @list ||= Color.select(:name).pluck(:name).sort
  end
end
