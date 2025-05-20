```
LDLt <: Factorization
```

実数の [`SymTridiagonal`](@ref) 行列 `S` の `LDLt` 因子分解の行列因子分解タイプで、`S = L*Diagonal(d)*L'` となります。ここで、`L` は [`UnitLowerTriangular`](@ref) 行列で、`d` はベクトルです。`LDLt` 因子分解 `F = ldlt(S)` の主な用途は、線形方程式系 `Sx = b` を `F\b` で解くことです。これは、対応する行列因子分解関数 [`ldlt`](@ref) の戻り値の型です。

因子分解 `F::LDLt` の個々のコンポーネントには `getproperty` を介してアクセスできます：

| コンポーネント | 説明                     |
|:-------:|:---------------------- |
|  `F.L`  | `LDLt` の `L`（単位下三角）部分  |
|  `F.D`  | `LDLt` の `D`（対角）部分     |
| `F.Lt`  | `LDLt` の `Lt`（単位上三角）部分 |
|  `F.d`  | `D` の対角値を持つ `Vector`   |

# 例

```jldoctest
julia> S = SymTridiagonal([3., 4., 5.], [1., 2.])
3×3 SymTridiagonal{Float64, Vector{Float64}}:
 3.0  1.0   ⋅
 1.0  4.0  2.0
  ⋅   2.0  5.0

julia> F = ldlt(S)
LDLt{Float64, SymTridiagonal{Float64, Vector{Float64}}}
L 因子:
3×3 UnitLowerTriangular{Float64, SymTridiagonal{Float64, Vector{Float64}}}:
 1.0        ⋅         ⋅
 0.333333  1.0        ⋅
 0.0       0.545455  1.0
D 因子:
3×3 Diagonal{Float64, Vector{Float64}}:
 3.0   ⋅        ⋅
  ⋅   3.66667   ⋅
  ⋅    ⋅       3.90909
```
