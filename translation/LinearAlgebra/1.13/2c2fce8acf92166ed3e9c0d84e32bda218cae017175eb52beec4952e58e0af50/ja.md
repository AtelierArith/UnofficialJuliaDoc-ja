```julia
ldlt(S::SymTridiagonal) -> LDLt
```

実対称三重対角行列 `S` を `LDLt`（すなわち ``LDL^T``）分解し、`S = L*Diagonal(d)*L'` を満たすようにします。ここで、`L` は単位下三角行列、`d` はベクトルです。`LDLt` 分解 `F = ldlt(S)` の主な用途は、`Sx = b` を `F\b` として線形方程式系を解くことです。

任意の対称行列またはエルミート行列をピボット選択付きで分解する、類似の手法については [`bunchkaufman`](@ref) も参照してください。

# Examples

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
