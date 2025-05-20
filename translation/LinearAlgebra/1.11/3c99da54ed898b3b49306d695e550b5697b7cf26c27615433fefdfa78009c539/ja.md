```
inv(M)
```

行列の逆行列。行列 `M` と `N` の積が単位行列 `I` になるような行列 `N` を計算します。これは左除算 `N = M \ I` を解くことによって計算されます。

# 例

```jldoctest
julia> M = [2 5; 1 3]
2×2 Matrix{Int64}:
 2  5
 1  3

julia> N = inv(M)
2×2 Matrix{Float64}:
  3.0  -5.0
 -1.0   2.0

julia> M*N == N*M == Matrix(I, 2, 2)
true
```
