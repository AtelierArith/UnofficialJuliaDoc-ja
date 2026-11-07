```julia
inv(M)
```

行列の逆行列。`N`を計算します。`M * N = I`が成り立つようにします。ここで、`I`は単位行列です。左除算`N = M \ I`を解くことで計算されます。

数値的な逆行列計算に`M`が失敗すると、[`SingularException`](@ref)がスローされます。

# Examples

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
