```julia
StepRange{T, S} <: OrdinalRange{T, S}
```

Ranges with elements of type `T` with spacing of type `S`. The step between each element is constant, and the range is defined in terms of a `start` and `stop` of type `T` and a `step` of type `S`. Neither `T` nor `S` should be floating point types. The syntax `a:b:c` with `b != 0` and `a`, `b`, and `c` all integers creates a `StepRange`.

# Examples

```jldoctest
julia> collect(StepRange(1, Int8(2), 10))
5-element Vector{Int64}:
 1
 3
 5
 7
 9

julia> typeof(StepRange(1, Int8(2), 10))
StepRange{Int64, Int8}

julia> typeof(1:3:6)
StepRange{Int64, Int64}
```
