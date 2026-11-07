```julia
ldlt(S::SymTridiagonal) -> LDLt
```

実対称三重対角行列 `S` の `LDLt`（すなわち ``LDL^T``）分解を計算します。分解は `S = L*Diagonal(d)*L'` を満たし、`L` は単位下三角行列、`d` はベクトルです。`LDLt` 分解 `F = ldlt(S)` の主な用途は、`F\b` を用いて連立一次方程式 `Sx = b` を解くことです。

任意の対称行列またはエルミート行列をピボット付きで分解する類似の方法については、[`bunchkaufman`](@ref) を参照してください。

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
