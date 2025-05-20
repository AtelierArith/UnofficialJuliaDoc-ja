```
IdSet{T}([itr])
IdSet()
```

IdSet{T}() は、型 `T` の値に対して `===` を等価性として使用してセット（[`Set`](@ref) を参照）を構築します。

以下の例では、値はすべて `isequal` であるため、通常の `Set` では上書きされます。`IdSet` は `===` で比較するため、3つの異なる値を保持します。

# 例

```jldoctest; filter = r"\n\s*(1|1\.0|true)"
julia> Set(Any[true, 1, 1.0])
Set{Any} with 1 element:
  1.0

julia> IdSet{Any}(Any[true, 1, 1.0])
IdSet{Any} with 3 elements:
  1.0
  1
  true
```
