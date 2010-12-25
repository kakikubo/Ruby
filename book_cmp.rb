class Book
  include Comparable

  def <=>(other)
    t = @genre.to_s <=> other.genre.to_s #ジャンルを比較
    return t if t != 0
    return @title <=> other.title
  end

  attr_accessor :title, :author, :genre

  def initialize(title,author,genre=nil)
    @title = title
    @author = author
    @genre = genre
  end
end

