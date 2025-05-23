```
arg_read(f::Function, arg::ArgRead) -> f(arg_io)
```

`arg_read` 関数は、次のいずれかの引数 `arg` を受け入れます：

  * `AbstractString`: 読み取りのために開かれるファイルパス
  * `AbstractCmd`: 標準出力から読み取るコマンド
  * `IO`: 読み取るために開かれた IO ハンドル

本体が通常の戻り値を返すかエラーをスローするかにかかわらず、開かれたパスは `arg_read` から戻る前に閉じられ、`IO` ハンドルは `arg_read` から戻る前にフラッシュされますが、閉じられません。

注意：ファイルを開くとき、ArgTools はファイル `open(...)` 呼び出しに `lock = false` を渡します。したがって、この関数から返されるオブジェクトは複数のスレッドから使用されるべきではありません。この制限は将来的に緩和される可能性がありますが、動作しているコードを壊すことはありません。
