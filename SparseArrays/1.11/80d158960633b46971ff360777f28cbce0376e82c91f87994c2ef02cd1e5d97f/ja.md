`ReadOnly{T,N,<:AbstractArray{T,N,V<:AbstractArray{T,N}}} <: AbstractArray{T,N}`

内部。変更をブロックする`AbstractArray`のラッパー。実質的にノーオペレーションの操作はブロックされません。例えば、`setindex!(x, getindex(x, i...), i...)`や`resize!(x, length(x))`は、`x isa ReadOnly`の場合においてはブロックされません。
