`ReadOnly{T,N,<:AbstractArray{T,N,V<:AbstractArray{T,N}}} <: AbstractArray{T,N}`

Internal. Wrapper around an `AbstractArray` that blocks change. Practically no-op operations are not blocked. For instance, `setindex!(x, getindex(x, i...), i...)` or `resize!(x, length(x))` for `x isa ReadOnly`.
