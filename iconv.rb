require "iconv"

result = ""
# EUC string to UTF-8
euc_str = "���ܸ�EUC��ʸ����"
utf8_str = Iconv.conv("UTF-8","EUC-JP",euc_str)
p result
