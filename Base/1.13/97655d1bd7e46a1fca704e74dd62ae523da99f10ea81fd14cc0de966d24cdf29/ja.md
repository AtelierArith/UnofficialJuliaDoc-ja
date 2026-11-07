```julia
VecOrMat{T}
```

関数が行列またはベクトルのどちらかを受け取れるようにする、[`Vector{T}`](@ref)と[`Matrix{T}`](@ref)の共用体型。

# Examples

```jldoctest
julia> Vector{Float64} <: VecOrMat{Float64}
true

julia> Matrix{Float64} <: VecOrMat{Float64}
true

julia> Array{Float64, 3} <: VecOrMat{Float64}
false
```
