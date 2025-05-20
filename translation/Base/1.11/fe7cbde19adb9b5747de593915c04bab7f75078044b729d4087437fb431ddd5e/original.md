```
VecOrMat{T}
```

Union type of [`Vector{T}`](@ref) and [`Matrix{T}`](@ref) which allows functions to accept either a Matrix or a Vector.

# Examples

```jldoctest
julia> Vector{Float64} <: VecOrMat{Float64}
true

julia> Matrix{Float64} <: VecOrMat{Float64}
true

julia> Array{Float64, 3} <: VecOrMat{Float64}
false
```
