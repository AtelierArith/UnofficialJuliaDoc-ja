```julia
UnionAll
```

型パラメーターが取り得るすべての値に対する型の和集合。`UnionAll`は、一部のパラメーターの値が不明なパラメトリック型を表すために使われます。[UnionAll Types](@ref)のマニュアルの節を参照してください。

# Examples

```jldoctest
julia> typeof(Vector)
UnionAll

julia> typeof(Vector{Int})
DataType
```
