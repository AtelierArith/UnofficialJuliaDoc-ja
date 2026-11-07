```julia
from_interprocedural(argescape::ArgEscapeInfo, pc::Int) -> x::EscapeInfo
```

呼び出し元フレームのコンテキストで、`pc`が戻り値のSSA文番号である場合に、`argescape`としてキャッシュされている呼び出し引数に適用されたエスケープ情報を再解釈します。
