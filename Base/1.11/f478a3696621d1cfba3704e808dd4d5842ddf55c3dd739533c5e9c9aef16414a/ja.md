```
getindex(A, inds...)
```

インデックス `inds` によって選択された配列 `A` のサブセットを返します。

各インデックスは、[`Integer`](@ref)、[`CartesianIndex`](@ref)、[range](@ref Base.AbstractRange)、またはサポートされているインデックスの[配列](@ref man-multi-dim-arrays)など、任意の[サポートされているインデックスタイプ](@ref man-supported-index-types)である可能性があります。特定の次元に沿ってすべての要素を選択するために、[: ](@ref Base.Colon)を使用することができ、対応するインデックスが `true` である要素をフィルタリングするために、ブール配列（例：`Array{Bool}` または [`BitArray`](@ref)）を使用することができます。

`inds` が複数の要素を選択する場合、この関数は新しく割り当てられた配列を返します。コピーを作成せずに複数の要素にインデックスを付けるには、代わりに [`view`](@ref) を使用してください。

詳細については、[配列インデックス](@ref man-array-indexing)に関するマニュアルセクションを参照してください。

# 例

```jldoctest
julia> A = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> getindex(A, 1)
1

julia> getindex(A, [2, 1])
2-element Vector{Int64}:
 3
 1

julia> getindex(A, 2:4)
3-element Vector{Int64}:
 3
 2
 4

julia> getindex(A, 2, 1)
3

julia> getindex(A, CartesianIndex(2, 1))
3

julia> getindex(A, :, 2)
2-element Vector{Int64}:
 2
 4

julia> getindex(A, 2, :)
2-element Vector{Int64}:
 3
 4

julia> getindex(A, A .> 2)
2-element Vector{Int64}:
 3
 4
```
