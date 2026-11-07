```julia
lmul!(a::Number, B::AbstractArray)
```

配列 `B` をスカラー `a` でスケーリングし、`B` をインプレースで上書きします。スカラーを右から乗算するには [`rmul!`](@ref) を使用します。このスケーリング操作は、`a` と `B` の要素との乗算 [`*`](@ref) の意味に従います。特に、`NaN` や `±Inf` などの非有限数を含む乗算にも適用されます。

!!! compat "Julia 1.1"
    Julia 1.1 より前は、`B` 内の `NaN` および `±Inf` のエントリは、一貫性のない扱いを受けていました。


# Examples

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
