```julia
eachrow(A::AbstractVecOrMat) <: AbstractVector
```

行列またはベクトル`A`の行を要素とするベクトルである[`RowSlices`](@ref)オブジェクトを作成します。行のスライスは、`A`の`AbstractVector`ビューとして返されます。

逆の操作については、[`stack`](@ref)`(rows; dims=1)`を参照してください。

[`eachcol`](@ref)、[`eachslice`](@ref)、[`mapslices`](@ref)も参照してください。

!!! compat "Julia 1.1"
    この関数を使用するには、Julia 1.1以降が必要です。


!!! compat "Julia 1.9"
    Julia 1.9より前のバージョンでは、これはイテレーターを返していました。


# Examples

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
