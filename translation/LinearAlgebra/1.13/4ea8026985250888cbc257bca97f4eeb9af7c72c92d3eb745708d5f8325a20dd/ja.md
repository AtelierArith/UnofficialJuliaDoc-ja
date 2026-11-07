```julia
rmul!(A::AbstractArray, b::Number)
```

配列 `A` にスカラー `b` を乗算し、`A` をインプレースで上書きします。スカラーを左から乗算するには [`lmul!`](@ref) を使用します。このスケーリング操作は、`A` の要素と `b` の間の乗算 [`*`](@ref) のセマンティクスに従います。特に、`NaN` や `±Inf` などの非有限数を含む乗算にも適用されます。

!!! compat "Julia 1.1"
    Julia 1.1 より前は、`A` 内の `NaN` および `±Inf` のエントリは、一貫性のない扱いを受けていました。


# Examples

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
