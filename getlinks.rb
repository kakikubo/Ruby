require 'htmlscanner'
### FIXME 結局動作させるには至らなかった
Link = Struct.new(:url, :text)

def getlinks(data)
  list = Array.new
  current = nil

  HTML.scan(data){ |item|
    case item
    when HTML::StartTag
      case item.name
      when "A"
        # A要素の開始タグを受け取ったら、新しい Link オブジェクトを生成する
        current = Link.new(item.attribute['href'],"")
      when "IMG"
        # IMG要素は内容を持たないので、そのままリストに追加する
        src = item.attribute['src']
        alt = item.attribute['alt']
        list.push(Link.new(src,alt))
        current.text << alt if current
      end
    when HTML::EndTag
      if item.name == "A" and current
        # A要素の終了タグを受け取ったら、currentをリストに追加する
        list.push(current) if current.url
        current = nil
      end
    when HTML::TextData
      current.text << item.value if current
    end

  }
  return list
end

# main
data = open(ARGV[0]){ |io| io.read
  list = getlinks(data)
  list.each{ |link|
    next unless /^http:/ =~ link.url
    link.text.gsub!(/\s+/, " ")
    link.text.gsub!(/ $/, "")
    link.text.gsub!(/^ /,"")
    puts link.text
    pus "   " + link.url
  }
}
