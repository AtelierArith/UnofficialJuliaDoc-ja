```julia
SymTridiagonal(dv::V, ev::V) where V <: AbstractVector
```

対角成分（`dv`）と第1副対角成分（上副対角・下副対角）（`ev`）から、対称三重対角行列を構築します。結果の型は`SymTridiagonal`で、専用の効率的な固有値ソルバーを利用できます。また、[`convert(Array, _)`](@ref)（または簡潔な`Array(_)`）を使って通常の行列に変換することもできます。

`SymTridiagonal`ブロック行列の場合、`dv`の要素は対称化されます。引数`ev`は上副対角として解釈されます。下副対角のブロックは、対応する上副対角ブロックを（実体化した）転置にしたものです。

# Examples

```jldoctest
julia> dv = [1, 2, 3, 4]
4-element Vector{Int64}:
 1
 2
 3
 4

julia> ev = [7, 8, 9]
3-element Vector{Int64}:
 7
 8
 9

julia> SymTridiagonal(dv, ev)
4×4 SymTridiagonal{Int64, Vector{Int64}}:
 1  7  ⋅  ⋅
 7  2  8  ⋅
 ⋅  8  3  9
 ⋅  ⋅  9  4

julia> A = SymTridiagonal(fill([1 2; 3 4], 3), fill([1 2; 3 4], 2));

julia> A[1,1]
2×2 Symmetric{Int64, Matrix{Int64}}:
 1  2
 2  4

julia> A[1,2]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> A[2,1]
2×2 Matrix{Int64}:
 1  3
 2  4
```
