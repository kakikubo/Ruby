require "iconv"

result = ""
# EUC string to UTF-8
euc_str = "日本語EUCの文字列"
utf8_str = Iconv.conv("UTF-8","EUC-JP",euc_str)
p result
