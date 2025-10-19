```julia
UnionAll
```

型パラメータのすべての値に対する型の和。`UnionAll`は、いくつかのパラメータの値が不明な場合のパラメトリック型を記述するために使用されます。マニュアルの[UnionAll Types](@ref)のセクションを参照してください。

# 例

```jldoctest
julia> typeof(Vector)
UnionAll

julia> typeof(Vector{Int})
DataType
```
