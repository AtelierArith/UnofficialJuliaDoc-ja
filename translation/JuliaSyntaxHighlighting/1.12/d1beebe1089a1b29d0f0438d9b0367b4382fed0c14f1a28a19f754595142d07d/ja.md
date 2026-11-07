```julia
_hl_annotations(content::AbstractString, ast::GreenNode)
  -> Vector{@NamedTuple{region::UnitRange{Int}, label::Symbol, value::Any}}
```

指定された`content`と`ast`に対する注釈のリストを生成します。

各注釈は`@NamedTuple{region::UnitRange{Int}, label::Symbol, value::Any}`の形式で、regionは`content`内のインデックスを示し、valueは`julia_*`のフェイス名を示します。

これは、利便性のための[`_hl_annotations!`](@ref)の小さなラッパーです。
