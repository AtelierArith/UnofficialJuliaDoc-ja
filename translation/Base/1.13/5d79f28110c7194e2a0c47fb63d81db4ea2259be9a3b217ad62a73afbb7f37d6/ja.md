```julia
annotations(chr::AnnotatedChar)::Vector{@NamedTuple{label::Symbol, value}}
```

`chr` のすべてのアノテーションを、アノテーションのペアを要素とするベクトルとして取得します。
