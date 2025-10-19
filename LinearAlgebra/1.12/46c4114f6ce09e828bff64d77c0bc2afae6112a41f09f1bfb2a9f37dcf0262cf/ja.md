```julia
lmul!(a::Number, B::AbstractArray)
```

スカラー `a` で配列 `B` をスケーリングし、`B` をその場で上書きします。スカラーを右から掛けるには [`rmul!`](@ref) を使用してください。スケーリング操作は、`a` と `B` の要素との間の乗算 [`*`](@ref) の意味論を尊重します。特に、これは `NaN` や `±Inf` のような非有限数を含む乗算にも適用されます。

!!! compat "Julia 1.1"
    Julia 1.1 より前は、`B` の `NaN` および `±Inf` エントリは一貫性がなく扱われていました。


# 例

```jldoctest
julia> B = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> lmul!(2, B)
2×2 Matrix{Int64}:
 2  4
 6  8

julia> lmul!(0.0, [Inf])
1-element Vector{Float64}:
 NaN
```
