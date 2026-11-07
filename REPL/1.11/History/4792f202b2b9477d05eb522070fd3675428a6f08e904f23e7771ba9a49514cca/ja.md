```julia
ConditionSet(spec::AbstractString) -> ConditionSet
```

生の検索文字列 `spec` を解析して、`ConditionSet` に変換します。

解析では、エスケープされていない `FILTER_SEPARATOR` で分割し、各セグメントを先頭のプレフィックス文字に応じて処理します。
