```julia
analyze_escapes(ir::IRCode, nargs::Int, get_escape_cache) -> estate::EscapeState
```

`ir`内のエスケープ情報を分析します：

  * `nargs`: 分析対象の呼び出しの実際の引数の数
  * `get_escape_cache(::MethodInstance) -> Union{Bool,ArgEscapeCache}`: キャッシュされた引数エスケープ情報を取得します
