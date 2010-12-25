### FIXME 結局動作させるには至らなかった


#1番目にマッチするもの：コメント
#2番目にマッチするもの：タグ
#3番目にマッチするもの：テキストデータ
HTMLRegexp = /(<!--.*?--\s*>)|
              (<(?:[^"'>]*|"[^"]*"|'[^']*')+>)|
              ([^<]*)/xm

#'

data = DATA.read # __END__ 以降の部分はDATAから読む事ができます


data.scan(HTMLRegexp){|match|
  comment, tag, tdata = match[0..2]
  if comment
    p [ "Comment", comment]
  elsif tag
    p [ "Tag", tag]
  elsif tdata
    tdata.gsub!(/\s+/," ")
    tdata.sub!(/ $/, "")
    p [ "TextData", tdata] unless tdata.empty?

    end
}
__END__
<!DOCTYPE HTML>
  <HTML>
  <BODY>
  <A name="FOO" href="foo" attr >foo</A>
  <A name="BAR" href="bar" attr >bar</A>
  <A name=BAZ href=baz attr >baz</A>
<!--
<A href="dummy">dummy</A>
  -->
  </BODY>
</HTML>



