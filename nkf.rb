require "nkf"

euc_str = "���ܸ��ʸ����"
utf8_str = NKF.nkf("-E ", euc_str)
puts utf8_str

