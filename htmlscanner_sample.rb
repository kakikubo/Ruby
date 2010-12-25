### FIXME 結局動作させるには至らなかった
require 'htmlscanner.rb'

data = DATA.read # __END__ 以降の部分はdataから読む事ができます

HTML.scan(data){ |item|
  case item
  when HTML::Comment
    p [ item.type, item.value ]
  when HTML::MarkUpDecl
    p [ item.type, item.value ]
  when HTML::StartTag
    p [ item.type, item.name, item.attribute ]
  when HTML::EndTag
    p [ item.type, item.name ]
  when HTML::TextData
    tdata = item.value
    tdata.gsub!(/\s+/," ")
    tdata.sub!(/ $/, "")
    p [ item.type, tdata ] unless tdata.empty?
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

