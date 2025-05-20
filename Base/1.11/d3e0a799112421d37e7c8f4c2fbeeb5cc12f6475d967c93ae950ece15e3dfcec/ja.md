```
diff(A::AbstractVector)
diff(A::AbstractArray; dims::Integer)
```

ベクトルまたは多次元配列 `A` に対する有限差分演算子。後者の場合、操作する次元は `dims` キーワード引数で指定する必要があります。

!!! compat "Julia 1.1"
    次元が2より大きい配列に対する `diff` は、少なくともJulia 1.1が必要です。


# 例

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
