require "nkf"

euc_str = "日本語の文字列"
utf8_str = NKF.nkf("-E ", euc_str)
puts utf8_str

