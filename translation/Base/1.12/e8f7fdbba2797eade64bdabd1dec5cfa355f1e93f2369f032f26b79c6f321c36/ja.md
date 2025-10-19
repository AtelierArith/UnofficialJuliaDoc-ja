```julia
eachcol(A::AbstractVecOrMat) <: AbstractVector
```

行列またはベクトル `A` の列のベクトルである [`ColumnSlices`](@ref) オブジェクトを作成します。列スライスは `A` の `AbstractVector` ビューとして返されます。

逆に関しては、[`stack`](@ref)`(cols)` または `reduce(`[`hcat`](@ref)`, cols)` を参照してください。

他にも [`eachrow`](@ref)、[`eachslice`](@ref)、および [`mapslices`](@ref) を参照してください。

!!! compat "Julia 1.1"
    この関数は少なくとも Julia 1.1 が必要です。


!!! compat "Julia 1.9"
    Julia 1.9 より前は、これがイテレータを返していました。


# 例

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
