```julia
eachrow(A::AbstractVecOrMat) <: AbstractVector
```

行列またはベクトル `A` の行のベクトルである [`RowSlices`](@ref) オブジェクトを作成します。行スライスは `A` の `AbstractVector` ビューとして返されます。

逆については [`stack`](@ref)`(rows; dims=1)` を参照してください。

他にも [`eachcol`](@ref)、[`eachslice`](@ref)、および [`mapslices`](@ref) を参照してください。

!!! compat "Julia 1.1"
    この関数は少なくとも Julia 1.1 を必要とします。


!!! compat "Julia 1.9"
    Julia 1.9 より前は、これがイテレータを返していました。


# 例

```jldoctest
julia> a = [1 2; 3 4]
2×2 Matrix{Int64}:
 1  2
 3  4

julia> s = eachrow(a)
2-element RowSlices{Matrix{Int64}, Tuple{Base.OneTo{Int64}}, SubArray{Int64, 1, Matrix{Int64}, Tuple{Int64, Base.Slice{Base.OneTo{Int64}}}, true}}:
 [1, 2]
 [3, 4]

julia> s[1]
2-element view(::Matrix{Int64}, 1, :) with eltype Int64:
 1
 2
```
