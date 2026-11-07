```julia
diff(A::AbstractVector)
diff(A::AbstractArray; dims::Integer)
```

ベクトルまたは多次元配列 `A` に対する有限差分演算子です。後者の場合は、演算対象の次元をキーワード引数 `dims` で指定する必要があります。

!!! compat "Julia 1.1"
    次元が 2 を超える配列に対する `diff` の使用には、Julia 1.1 以降が必要です。


# Examples

```jldoctest
julia> a = [2 4; 6 16]
2×2 Matrix{Int64}:
 2   4
 6  16

julia> diff(a, dims=2)
2×1 Matrix{Int64}:
  2
 10

julia> diff(vec(a))
3-element Vector{Int64}:
  4
 -2
 12
```
