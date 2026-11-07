```julia
argextype(x, src::Union{IRCode,IncrementalCompact}) -> t
argextype(x, src::CodeInfo, sptypes::Vector{VarState}) -> t
```

推論されたソース `src` のコンテキストにおける、値 `x` の型を返します。`t` は拡張格子要素である可能性があることに注意してください。`x` のネイティブな Julia 型を取得するには、`widenconst(t)` を使用してください。
