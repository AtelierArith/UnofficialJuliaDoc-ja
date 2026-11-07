`ReadOnly{T,N,<:AbstractArray{T,N,V<:AbstractArray{T,N}}} <: AbstractArray{T,N}`

内部用。変更をブロックする `AbstractArray` のラッパーです。実質的に何も変更しない操作はブロックされません。たとえば、`x isa ReadOnly` に対する `setindex!(x, getindex(x, i...), i...)` や `resize!(x, length(x))` です。
