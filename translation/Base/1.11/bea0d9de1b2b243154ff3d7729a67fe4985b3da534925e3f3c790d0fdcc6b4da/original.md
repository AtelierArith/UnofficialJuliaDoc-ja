```
LogRange{T}(start, stop, len) <: AbstractVector{T}
```

A range whose elements are spaced logarithmically between `start` and `stop`, with spacing controlled by `len`. Returned by [`logrange`](@ref).

Like [`LinRange`](@ref), the first and last elements will be exactly those provided, but intermediate values may have small floating-point errors. These are calculated using the logs of the endpoints, which are stored on construction, often in higher precision than `T`.

# Examples

```jldoctest
julia> logrange(1, 4, length=5)
5-element Base.LogRange{Float64, Base.TwicePrecision{Float64}}:
 1.0, 1.41421, 2.0, 2.82843, 4.0

julia> Base.LogRange{Float16}(1, 4, 5)
5-element Base.LogRange{Float16, Float64}:
 1.0, 1.414, 2.0, 2.828, 4.0

julia> logrange(1e-310, 1e-300, 11)[1:2:end]
6-element Vector{Float64}:
 1.0e-310
 9.999999999999974e-309
 9.999999999999981e-307
 9.999999999999988e-305
 9.999999999999994e-303
 1.0e-300

julia> prevfloat(1e-308, 5) == ans[2]
true
```

Note that integer eltype `T` is not allowed. Use for instance `round.(Int, xs)`, or explicit powers of some integer base:

```jldoctest
julia> xs = logrange(1, 512, 4)
4-element Base.LogRange{Float64, Base.TwicePrecision{Float64}}:
 1.0, 8.0, 64.0, 512.0

julia> 2 .^ (0:3:9) |> println
[1, 8, 64, 512]
```

!!! compat "Julia 1.11"
    This type requires at least Julia 1.11.

