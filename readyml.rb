require 'pp'
require 'yaml'


# mongrelクラスターのymlファイルを配列に指定する。この処理でとりあえずは取り出せる。
config_files = ["mongrel.yml","mongrel2.yml"]
@array = []
config_files.each{ |y|
  config = YAML.load_file(y)
  servers = config["servers"]
  port    = config["port"].to_i
  servers.times{
    @array << config.dup # ここでそのまま配列を渡すと
    config["port"] = config["port"] + 1 # この行の変更がオブジェクトに対して行われてしまうので注意
  }
}

pp @array

