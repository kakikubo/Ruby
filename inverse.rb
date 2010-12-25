# 自作の例外クラス定義
class NotInvertibleError < StandardError
end

# 自作例外クラスを早速使う
def inverse(x)
  raise NotInvertibleError, "Argument is not numeric" unless x.is_a?(Numeric)
  p 1.0 / x
end

inverse(2)
inverse(3)
inverse("a")

