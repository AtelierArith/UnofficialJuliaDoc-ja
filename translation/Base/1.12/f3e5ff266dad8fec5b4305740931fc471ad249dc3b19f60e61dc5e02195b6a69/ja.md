```julia
annotations(chr::AnnotatedChar) -> Vector{@NamedTuple{label::Symbol, value}}
```

`chr`のすべての注釈を、注釈ペアのベクトルの形式で取得します。
