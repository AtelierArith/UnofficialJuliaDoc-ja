```julia
eachcol(A::AbstractVecOrMat) <: AbstractVector
```

行列またはベクトル `A` の各列を要素とするベクトルである [`ColumnSlices`](@ref) オブジェクトを作成します。列のスライスは、`A` の `AbstractVector` ビューとして返されます。

逆の操作については、[`stack`](@ref)`(cols)` または `reduce(`[`hcat`](@ref)`, cols)` を参照してください。

[`eachrow`](@ref)、[`eachslice`](@ref)、[`mapslices`](@ref) も参照してください。

!!! compat "Julia 1.1"
    この関数には Julia 1.1 以降が必要です。


!!! compat "Julia 1.9"
    Julia 1.9 より前では、この関数はイテレータを返していました。


# Examples

```jldoctest
julia> a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> s = eachcol(a)
2-element ColumnSlices{Matrix{Int64}, Tuple{Base.OneTo{Int64}}, SubArray{Int64, 1, Matrix{Int64}, Tuple{Base.Slice{Base.OneTo{Int64}}, Int64}, true}}:
 [1, 3]
 [2, 4]

julia> s[1]
2-element view(::Matrix{Int64}, :, 1) with eltype Int64:
 1
 3
```
