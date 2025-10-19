```julia
inv(M)
```

行列の逆行列。行列 `N` を計算し、`M * N = I` となるようにします。ここで `I` は単位行列です。左除算 `N = M \ I` を解くことで計算されます。

`M` が数値的逆行列を持たない場合、[`SingularException`](@ref) がスローされます。

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
