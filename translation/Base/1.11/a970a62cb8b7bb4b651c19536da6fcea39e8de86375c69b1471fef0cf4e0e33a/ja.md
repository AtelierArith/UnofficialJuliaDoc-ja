```
sum(f, A::AbstractArray; dims)
```

配列の各要素に対して関数 `f` を呼び出した結果を、指定された次元にわたって合計します。

# 例

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> sum(abs2, A, dims=1)
1×2 Matrix{Int64}:
 10  20

julia> sum(abs2, A, dims=2)
2×1 Matrix{Int64}:
  5
 25
```
