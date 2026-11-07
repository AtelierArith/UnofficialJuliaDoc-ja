```julia
enable_in_core!([enable=true; freeze_world_age=true, debug_filename=nothing])
```

JuliaSyntax パーサーを Julia ランタイムに接続し、すべての解析処理で flisp パーサーに置き換えます。つまり、`include()`、`Meta.parse()`、REPL などで JuliaSyntax が使用されます。参照パーサーに戻すには、`enable_in_core!(false)` を使用します。

キーワード引数:

  * `freeze_world_age` - パーサーのワールドエイジを固定し、ユーザー定義メソッドによるパーサーの再コンパイルを防ぎます（デフォルトは `true`）。
  * `debug_filename` - パーサーのデバッグログのファイル名です（デフォルトは `nothing`、または `ENV["JULIA_SYNTAX_DEBUG_FILE"]` の値です）。
