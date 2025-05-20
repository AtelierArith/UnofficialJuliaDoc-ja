```
rmul!(A::AbstractArray, b::Number)
```

スカラー `b` で配列 `A` をスケーリングし、`A` をその場で上書きします。スカラーを左から掛けるには [`lmul!`](@ref) を使用してください。スケーリング操作は、`A` の要素と `b` の間の乗算 [`*`](@ref) の意味論を尊重します。特に、これは `NaN` や `±Inf` のような非有限数を含む乗算にも適用されます。

!!! compat "Julia 1.1"
    Julia 1.1 より前は、`A` の `NaN` および `±Inf` エントリは一貫性がなく扱われていました。


# 例

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> rmul!(A, 2)
2×2 Matrix{Int64}:
 2  4
 6  8

julia> rmul!([NaN], 0.0)
1-element Vector{Float64}:
 NaN
```
