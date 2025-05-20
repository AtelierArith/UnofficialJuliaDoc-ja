```
LU <: Factorization
```

正方行列 `A` の `LU` 分解の行列分解型です。これは、対応する行列分解関数 [`lu`](@ref) の戻り値の型です。

分解 `F::LU` の個々のコンポーネントには、[`getproperty`](@ref) を介してアクセスできます：

| コンポーネント | 説明                  |
|:------- |:------------------- |
| `F.L`   | `LU` の `L`（単位下三角）部分 |
| `F.U`   | `LU` の `U`（上三角）部分   |
| `F.p`   | （右）置換 `Vector`      |
| `F.P`   | （右）置換 `Matrix`      |

分解を反復すると、コンポーネント `F.L`、`F.U`、および `F.p` が生成されます。

# 例

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

julia> l, u, p = lu(A); # 反復を介した分解

julia> l == F.L && u == F.U && p == F.p
true
```
