```julia
_clear_annotations_in_region!(annotations::Vector{@NamedTuple{region::UnitRange{Int64}, label::Symbol, value}}, span::UnitRange{Int})
```

特定の`span`内にある`annotations`を消去します。

`span`に完全に含まれる`annotations`の要素をすべて削除し、一部が重なる範囲は切り詰めます。また、`span`を包含する注釈は分割し、`span`の両側にのみ存在するようにします。
