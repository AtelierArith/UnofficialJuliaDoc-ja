```
(:)(start::CartesianIndex, [step::CartesianIndex], stop::CartesianIndex)
```

Construct [`CartesianIndices`](@ref) from two `CartesianIndex` and an optional step.

!!! compat "Julia 1.1"
    This method requires at least Julia 1.1.


!!! compat "Julia 1.6"
    The step range method start:step:stop requires at least Julia 1.6.


# Examples

```jldoctest
julia> I = CartesianIndex(2,1);

julia> J = CartesianIndex(3,3);

julia> I:J
CartesianIndices((2:3, 1:3))

julia> I:CartesianIndex(1, 2):J
CartesianIndices((2:1:3, 1:2:3))
```
