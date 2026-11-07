```julia
LU <: Factorization
```

正方行列 `A` の `LU` 分解の行列分解型です。対応する行列分解関数 [`lu`](@ref) の戻り値の型です。

分解結果 `F::LU` の各成分には、[`getproperty`](@ref) を使ってアクセスできます。

| 成分    | 説明                  |
|:----- |:------------------- |
| `F.L` | `LU` の `L`（単位下三角）部分 |
| `F.U` | `LU` の `U`（上三角）部分   |
| `F.p` | （右）置換 `Vector`      |
| `F.P` | （右）置換 `Matrix`      |

分解結果を反復すると、成分 `F.L`、`F.U`、`F.p` が得られます。

# Examples

```jldoctest
julia> A = [4 3; 6 3]
2×2 Matrix{Int64}:
 4  3
 6  3

julia> F = lu(A)
LU{Float64, Matrix{Float64}, Vector{Int64}}
L factor:
2×2 Matrix{Float64}:
 1.0       0.0
 0.666667  1.0
U factor:
2×2 Matrix{Float64}:
 6.0  3.0
 0.0  1.0

julia> F.L * F.U == A[F.p, :]
true

julia> l, u, p = lu(A); # destructuring via iteration

julia> l == F.L && u == F.U && p == F.p
true
```
