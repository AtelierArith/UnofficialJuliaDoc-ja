```julia
elsize(type)
```

指定された `type` 内に格納された [`eltype`](@ref) について、配列要素が均一な線形ストライドで密に格納されている場合、隣接する要素間のメモリ上のストライドをバイト単位で求めてください。

# Examples

```jldoctest
julia> Base.elsize(rand(Float32, 10))
4
```
