class String
  alias buffer_size length
  def length
    self.split(//).length
  end
end

j_string = "日本語の文字列"
p j_string.buffer_size
p j_string.length

