require 'book'

class BookList
  ## 初期化
  def initialize()
    @booklist = Array.new
  end

  ## 新しい本を加える
  def add(book)
    @booklist.push(book)
  end

  ## 本の冊数を返す
  def length
    @booklist.length
  end

  ## n番目に格納されている本を別の本にする
  def []=(n,book)
    @booklist[n] = book
  end

  ## n番目に格納されている本を返す
  def [](n)
    @booklist[n]
  end

  ## 本をリストから削除する
  def delete(book)
    @booklist.delete(book)
  end

  ## イテレータを定義
  def each
    @booklist.each{ |book|
      yield(book)
    }
  end

  ## (タイトルだけ取ってくる)イテレータを定義
  def each_title
    @booklist.each{ |book|
      yield(book.title)
    }
  end
  ## タイトルと著者名を返すイテレータを定義
  def each_title_author
    @booklist.each{ |book|
      yield(book.title, book.author)
    }
  end

  def find_by_author(author)
    if block_given?
    @booklist.each{ |book|
        if author =~ book.author
          yield(book)
        end
      }
    else ## ブロックが無い場合
      result = []
      @booklist.each{ |book|
        if author =~ book.author
          result << book
        end
      }
    end
  end


end
