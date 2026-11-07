```julia
IdSet{T}([itr])
IdSet()
```

`IdSet{T}()` は、型 `T` の値を `===` で等しいとみなして集合を構築します（[`Set`](@ref)）。

以下の例では、値はすべて `isequal` なので、通常の `Set` では上書きされます。`IdSet` は `===` で比較するため、3つの異なる値が保持されます。

!!! compat "Julia 1.11"
    Julia 1.11以降でエクスポートされています。


# Examples

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
