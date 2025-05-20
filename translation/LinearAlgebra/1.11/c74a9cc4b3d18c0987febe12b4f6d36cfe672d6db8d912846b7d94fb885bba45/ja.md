```
SymTridiagonal(dv::V, ev::V) where V <: AbstractVector
```

対角成分（`dv`）と最初の下/上対角成分（`ev`）から対称トリジオナル行列を構築します。結果は `SymTridiagonal` 型であり、効率的な特化型固有値ソルバーを提供しますが、[`convert(Array, _)`](@ref)（または短縮形の `Array(_)`）を使用して通常の行列に変換することができます。

`SymTridiagonal` ブロック行列の場合、`dv` の要素は対称化されます。引数 `ev` は上対角成分として解釈されます。下対角成分のブロックは、対応する上対角成分のブロックの（具現化された）転置です。

# 例

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
