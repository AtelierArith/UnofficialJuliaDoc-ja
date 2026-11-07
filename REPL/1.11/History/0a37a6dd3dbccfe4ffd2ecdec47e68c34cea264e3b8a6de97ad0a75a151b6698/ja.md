```julia
matchregions(spec::FilterSpec, candidate::AbstractString) -> Vector{UnitRange{Int}}
```

`candidate` 内で `spec` に一致するすべての文字範囲を検索します。

完全一致と正規表現による一致を収集し、開始インデックス順（同じ場合は長い一致を先）に並べて返します。
