class String
  def to_dom_id
    self.downcase.gsub(/\s/, '-').gsub(/[^\w^\-]/, '')
  end
end
