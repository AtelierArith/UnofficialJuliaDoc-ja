```julia
ldlt(S::SymTridiagonal) -> LDLt
```

実数対称三重対角行列 `S` の `LDLt`（すなわち、$LDL^T$）因子分解を計算します。ここで、`S = L*Diagonal(d)*L'` となり、`L` は単位下三角行列、`d` はベクトルです。`LDLt` 因子分解 `F = ldlt(S)` の主な用途は、線形方程式系 `Sx = b` を `F\b` で解くことです。

任意の対称またはエルミート行列の類似のピボット付き因子分解については、[`bunchkaufman`](@ref) を参照してください。

# 例

```jldoctest
julia> S = SymTridiagonal([3., 4., 5.], [1., 2.])
3×3 SymTridiagonal{Float64, Vector{Float64}}:
 3.0  1.0   ⋅
 1.0  4.0  2.0
  ⋅   2.0  5.0

julia> ldltS = ldlt(S);

julia> b = [6., 7., 8.];

julia> ldltS \ b
3-element Vector{Float64}:
 1.7906976744186047
 0.627906976744186
 1.3488372093023255

julia> S \ b
3-element Vector{Float64}:
 1.7906976744186047
 0.627906976744186
 1.3488372093023255
```
