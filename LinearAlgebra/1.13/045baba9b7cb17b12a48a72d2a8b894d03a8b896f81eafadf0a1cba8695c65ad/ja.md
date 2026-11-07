```julia
LDLt <: Factorization
```

実数の [`SymTridiagonal`](@ref) 行列 `S` の `LDLt` 分解を表す行列因子分解型です。`S = L*Diagonal(d)*L'` が成り立ちます。ここで、`L` は [`UnitLowerTriangular`](@ref) 行列、`d` はベクトルです。`LDLt` 分解 `F = ldlt(S)` の主な用途は、`F\b` を用いて連立一次方程式 `Sx = b` を解くことです。これは、対応する行列因子分解関数 [`ldlt`](@ref) の戻り値の型です。

因子分解 `F::LDLt` の各成分には、`getproperty` を使ってアクセスできます。

|   成分   | 説明                           |
|:------:|:---------------------------- |
| `F.L`  | `LDLt` の `L`（単位下三角）部分        |
| `F.D`  | `LDLt` の `D`（対角）部分           |
| `F.Lt` | `LDLt` の `Lt`（単位上三角）部分       |
| `F.d`  | `D` の対角成分を `Vector` として表したもの |

# Examples

```jldoctest
julia> S = SymTridiagonal([3., 4., 5.], [1., 2.])
3×3 SymTridiagonal{Float64, Vector{Float64}}:
 3.0  1.0   ⋅
 1.0  4.0  2.0
  ⋅   2.0  5.0

julia> F = ldlt(S)
LDLt{Float64, SymTridiagonal{Float64, Vector{Float64}}}
L factor:
3×3 UnitLowerTriangular{Float64, SymTridiagonal{Float64, Vector{Float64}}}:
 1.0        ⋅         ⋅
 0.333333  1.0        ⋅
 0.0       0.545455  1.0
D factor:
3×3 Diagonal{Float64, Vector{Float64}}:
 3.0   ⋅        ⋅
  ⋅   3.66667   ⋅
  ⋅    ⋅       3.90909
```
