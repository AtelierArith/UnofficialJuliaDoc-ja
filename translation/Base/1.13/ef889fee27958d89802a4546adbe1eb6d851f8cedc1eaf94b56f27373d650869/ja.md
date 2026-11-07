```julia
keys(a::AbstractArray)
```

`a` のすべての有効なインデックスを、`a` 自体と同じ形状で表す、効率的な配列を返します。

1 次元配列（ベクトル）のキーは整数ですが、それ以外の N 次元配列では、位置を表すために [`CartesianIndex`](@ref) を使用します。整数の配列や `CartesianIndex` の配列を効率的に表すには、特殊な配列型である [`LinearIndices`](@ref) と [`CartesianIndices`](@ref) がよく使われます。

配列の `keys` が、最も効率的なインデックス型とは限りません。最高のパフォーマンスを得るには、代わりに [`eachindex`](@ref) を使用してください。

# Examples

```jldoctest
julia> keys([4, 5, 6])
3-element LinearIndices{1, Tuple{Base.OneTo{Int64}}}:
 1
 2
 3

julia> keys([4 5; 6 7])
CartesianIndices((2, 2))
```
