```
maximum(f, A::AbstractArray; dims)
```

与えられた次元にわたって配列の各要素に関数 `f` を適用することによって最大値を計算します。

# 例

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> maximum(abs2, A, dims=1)
1×2 Matrix{Int64}:
 9  16

julia> maximum(abs2, A, dims=2)
2×1 Matrix{Int64}:
  4
 16
```
