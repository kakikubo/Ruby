### FIXME 結局動作させるには至らなかった
module HTML
  #1番目にマッチするもの：コメント
  #2番目にマッチするもの：タグ
  #3番目にマッチするもの：テキストデータ
  HTMLRegexp = /(<!--.*?--\s*>)|
              (<(?:[^"'>]*|"[^"]*"|'[^']*')+>)|
              ([^<]*)/xm

  #'
  MarkUpDeclRegexp = /^<!/
  EndTagRegexp = /^<\/(\w+)>/
  StartTagRegexp = /^<(\w+)(.*)>/m
  AttrRegexp = /(\w+)(?:=(?:"([^"]*)"|'([^']*)'|([^'"\s]*)))?/

  # class Item: 解析結果を保存する為のクラス
  Item = Struct.new(:name, :attribute, :value, :source)
  class Comment    < Item; end
  class MarkUpDecl < Item; end
  class StartTag   < Item; end
  class EndTag     < Item; end
  class TextData   < Item; end

  def scan(data)
    data.scan(HTMLRegexp).each{|match|
      comment, tag, tdata = match[0..2]
      if comment
        /^<!--(.*)--\s*>/om =~ comment #コメントの内容を取りだす
        item = Comment.new(nil, nil, $1, comment)
      elsif tag
        case tag
          when MarkUpDeclRegexp
          item = MarkUpDecl.new(nil, nil, tag, tag)
          when EndTagRegexp
          item = EndTag.new($1.upcase, nil, nil, tag)
          when StartTagRegexp
          # タグから要素名と属性を取り出す
          # 要素名は大文字に変換する
          elem_name, attrs = $1.upcase, $2

          # 属性を１つずつ取り出してハッシュに格納する
          # 要素名は小文字に変換し、値はunescapeする
          attr = Hash.new
          attrs.scan(AttrRegexp){
            attr_name = $1
            value = $2 || $3 || $4 # $2から$4のうち、マッチしたもの
            attr[attr_name.downcase] = unescape(value)
          }
          item = StartTag.new(elem_name, attr, nil, tag)
        end
      elsif tdata
        item = TextData.new(nil, nil, unescape(tdata), tdata)
      end
      yield(item)
    }
  end
  module_function :scan


  def unescape(str)
    return nil unless str
    ret = str.dup
    ret.gsub!(/&#(\d+);|&(\w+);/) do | m|
      num, name = $1, $2
      if num          then num.to_i.chr
      elsif name == "quot" then '"'
      elsif name == "amp"  then '&'
      elsif name == "lt"  then '<'
      elsif name == "gt"  then '>'
      else m
      end
    end
    ret
  end
  module_function :unescape
end

