```julia
analyze_escapes(ir::IRCode, nargs::Int, get_escape_cache) -> estate::EscapeState
```

`ir` 内のエスケープ情報を解析します。

  * `nargs`: 解析対象の呼び出しにおける実引数の数
  * `get_escape_cache(::MethodInstance) -> Union{Bool,ArgEscapeCache}`: キャッシュされた引数のエスケープ情報を取得します
